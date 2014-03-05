Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaCEGfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:35:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaCEGfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:35:18 -0500
Date: Tue, 4 Mar 2014 22:35:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        tobias.polzer@fau.de, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, dominik.paulus@fau.de,
        ihadzic@research.bell-labs.com
Subject: Re: [PATCH 06/12] staging: usbip: userspace: add new list API
Message-ID: <20140305063539.GB8816@kroah.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
 <1393960252-21247-7-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393960252-21247-7-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 09:10:46PM +0200, Valentina Manea wrote:
> Add a new list API from CCAN.

Why can't you just take the one from the kernel, as userspace is GPLv2
code, right?

And are you sure CC0 is a "valid" license that you can mix with GPLv2
code?  I ask this seriously, as I have heard that CC0 really isn't even
a valid license at all, and if I was to accept this patch, I'm going to
have to go talk to some lawyers, which isn't going to be fun...

thanks,

greg k-h
