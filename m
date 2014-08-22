Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaHVPwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:52:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaHVPwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:52:36 -0400
Date: Fri, 22 Aug 2014 10:51:40 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Tim Niemeyer <tim.niemeyer@corscience.de>
Cc: Felipe Balbi <balbi@ti.com>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, jslaby@suse.cz,
        grant.likely@linaro.org, linux-bluetooth@vger.kernel.org,
        andreas@biessmann.de
Subject: Re: [PATCH] bluetooth: hci_ldisc: fix deadlock condition
Message-ID: <20140822155140.GA18880@kroah.com>
References: <1398265117-11793-2-git-send-email-balbi@ti.com>
 <1408715107-21299-1-git-send-email-tim.niemeyer@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408715107-21299-1-git-send-email-tim.niemeyer@corscience.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 03:45:07PM +0200, Tim Niemeyer wrote:
> This Patch was applied to 3.10 and 3.2. It's probably missed on 3.4.

Does it apply there?

What is the git id of the commit?

thanks,

greg k-h
