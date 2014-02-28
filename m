Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaB1WW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:22:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaB1WWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:22:25 -0500
Date: Fri, 28 Feb 2014 14:24:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: devel@driverdev.osuosl.org, lisa@xenapiadmin.com, lidza.louina@gmail.com,
        kernel-janitors@vger.kernel.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, rashika.kheria@gmail.com,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] staging: sb105x: b_pci_mp.c: fix for non-member access
Message-ID: <20140228222403.GA8543@kroah.com>
References: <1393554063-25823-1-git-send-email-gmate.amit@gmail.com>
 <20140228222040.GA27989@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140228222040.GA27989@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 02:20:40PM -0800, Greg KH wrote:
> On Fri, Feb 28, 2014 at 04:21:03AM +0200, Kumar Amit Mehta wrote:
> > 'struct tty_struct’ has no member named ‘low_latency’
> 
> This driver is marked BROKEN, and can't even compile, how did you test
> this patch?

Don't worry about it anymore, I've now deleted the driver entirely, as
no one has cared about it in the past year that it has been disabled
from the kernel build.

thanks,

greg k-h
