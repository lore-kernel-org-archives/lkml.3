Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbaGVWBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:01:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbaGVWBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:01:51 -0400
Date: Tue, 22 Jul 2014 15:01:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guillaume Clement <gclement@baobob.org>
Cc: Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: vt6655: change type of PortOffset to void
 __iomem *
Message-ID: <20140722220151.GA29251@kroah.com>
References: <1406059710-30903-1-git-send-email-gclement@baobob.org>
 <1406059710-30903-2-git-send-email-gclement@baobob.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406059710-30903-2-git-send-email-gclement@baobob.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 10:08:26PM +0200, Guillaume Clement wrote:
> PortOffset was an unsigned long, but used as an pointer to io
> memory. Sometimes it was not properly cast before use, which caused
> many warning by sparse.
> 
> By updating its type to void __iomem *, and reflecting the changes
> where it is needed, this removes most of those warnings.

Nice job, that's the correct way to fix this.

greg k-h
