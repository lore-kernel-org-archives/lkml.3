Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3JDVvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:51:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3JDVvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:51:36 -0400
Date: Fri, 4 Oct 2013 14:51:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: g_ffs: fix compilation warning
Message-ID: <20131004215156.GA10629@kroah.com>
References: <1380923326-18546-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380923326-18546-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 02:48:46PM -0700, David Cohen wrote:
> Due to lack of "u_ether.h" header file, g_ffs.c compiles with following
> warning:

It does?  In what tree/branch/release is this happening?

thanks,

greg k-h
