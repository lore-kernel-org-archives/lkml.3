Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3LORCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 12:02:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3LORCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 12:02:16 -0500
Date: Sun, 15 Dec 2013 09:04:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: BUG: key ffff8800192a6ad0 not in .data!
Message-ID: <20131215170417.GB28799@kroah.com>
References: <20131215063123.GB26396@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131215063123.GB26396@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 02:31:23PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is

I thought this was already fixed in Bjorn's tree, but perhaps he hasn't
merged in the one-liner for it...

thanks,

greg k-h
