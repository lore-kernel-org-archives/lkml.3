Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaCGGqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:46:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaCGGqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:46:49 -0500
Date: Thu, 6 Mar 2014 22:47:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "xinhui.pan" <xinhuix.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        sarah.a.sharp@linux.intel.com, dan.j.williams@intel.com,
        burzalodowa@gmail.com, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] usb/core/hub.c: return immediately when hub_port_init
 hits timedout
Message-ID: <20140307064718.GA20065@kroah.com>
References: <53196414.8090703@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53196414.8090703@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 02:15:48PM +0800, xinhui.pan wrote:
> From: "xinhui.pan" <xinhuiX.pan@intel.com>

I doubt your name as a "." in it, right?

> some devices go crasy, we can't resume it even after reset.

I don't understand, what do you mean by this?  What exactly does a
device do, and why does it do it?  And what happens?

> This case will cause timeout again and again. What is worse, if there
> is a watchdog, panic will be generated as timer expires.

A watchdog where?

> To prevent this, we just return -ENODEV immediately. Later it will be
> re-enumerated.

What will cause it to be re-enumerated?

confused,

greg k-h
