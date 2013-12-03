Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3LCRfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:35:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3LCRfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:35:39 -0500
Date: Tue, 3 Dec 2013 09:36:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Gary Rookard <garyrookard@gmail.com>
Cc: lisa@xenapiadmin.com, devel@driver.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: Fixed non_standard kernel style, also
 eliminated debug messages.
Message-ID: <20131203173641.GA22882@kroah.com>
References: <1386063346-11787-1-git-send-email-garyrookard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386063346-11787-1-git-send-email-garyrookard@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 04:35:46AM -0500, Gary Rookard wrote:
> Fixed non_standard kernel style, also eliminated debug messages. Started replacing CamelCase.

You are doing multiple things in one patch, never a good thing, please
break this up into logical, individual patches.

Also, it doesn't apply to my tree, use the staging-next branch of
staging.git on git.kernel.org or linux-next.

thanks,

greg k-h
