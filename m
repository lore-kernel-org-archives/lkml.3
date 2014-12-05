Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbaLECb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 21:31:26 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61595 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaLECbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 21:31:23 -0500
Date: Thu, 4 Dec 2014 18:31:19 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Scott Branden <sbranden@broadcom.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Ray Jui <rjui@broadcom.com>,
        Corneliu Doban <cdoban@broadcom.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: add reboot notifier to mtdcore and register
 nand_shutdown with notifier
Message-ID: <20141205023119.GM21347@ld-irv-0074>
References: <sbranden@broadcom.com>
 <1417732658-4563-1-git-send-email-sbranden@broadcom.com>
 <5480F88D.4090707@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5480F88D.4090707@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 04:13:01PM -0800, Scott Branden wrote:
> Apologies:  patch fails checkpatch due to spaces instead of tabs
> during cut and paste.
> 
> But, please comment on this patch before I create a new version.

I'd prefer the separation to be as I sent in the first place; one patch
to add a generic hook for all MTD's, and one to implement the hook in
NAND.

I can just resend my patch (fixed up to compile correctly; I had an
error previously), then you can just add your Tested-by.

Brian
