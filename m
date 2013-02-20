Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101Ab3BTQhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:37:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34793 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933743Ab3BTQhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:37:32 -0500
Date: Wed, 20 Feb 2013 11:37:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Manjunath Goudar <manjunath.goudar@linaro.org>
cc: linux-usb@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>, <arnd@linaro.org>, <gregkh@linuxfoundation.org>,
        Greg KH <greg@kroah.com>, Tony Prisk <linux@prisktech.co.nz>,
        Alexey Charkov <alchark@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [V2 5/8] USB: EHCI: make ehci-vt8500 a separate driver
In-Reply-To: <1360923853-7875-6-git-send-email-manjunath.goudar@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1302201125410.1671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013, Manjunath Goudar wrote:

> Separate the vt8500 host controller driver from ehci-hcd host code
> into its own driver module.
> 
> In V2:
> Change the GPL to GPL v2 MODULE_LICENSE 

Same comments as for the other patches.

You know, when you submit a series of patches all doing basically the
same sort of thing, and somebody makes a suggestion to improve one of
them, you should always consider whether that suggestion could also
apply to the other patches in the series.  It's silly for us to send
you 8 separate emails, each telling you to make the same change to one 
particular patch in the series.

Therefore you should consider each of the problems I have described in 
the last several emails, and think about which of your patches they 
apply to.  Some of them do apply to more than one patch, even though I 
didn't say so explicitly at the time.

Alan Stern

