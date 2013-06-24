Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab3FXWdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:33:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3FXWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:33:40 -0400
Date: Mon, 24 Jun 2013 15:33:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: navin patidar <navinp@cdac.in>
Cc: mfm@muteddisk.com, linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: replace pr_warning() with pr_warn()
Message-ID: <20130624223339.GB24099@kroah.com>
References: <1371807064-25221-1-git-send-email-navinp@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371807064-25221-1-git-send-email-navinp@cdac.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 03:01:04PM +0530, navin patidar wrote:
> pr_warn() is preferred over pr_warning().

And dev_warn() is preferred over both of them, can you convert the code
to use that instead?

thanks,

greg k-h
