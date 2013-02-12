Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab3BLAyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:54:13 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:35700 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab3BLAyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:54:07 -0500
Date: Mon, 11 Feb 2013 16:54:02 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Holger Hoffstaette <holger.hoffstaette@googlemail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [regression] external HDD in USB3 enclosure cannot be
 dynamically removed (Re: Linux 3.7.5)
Message-ID: <20130212005402.GB10897@google.com>
References: <20130128045658.GA3488@kroah.com>
 <pan.2013.01.28.11.42.16.556318@googlemail.com>
 <20130128143907.GA2940@kroah.com>
 <pan.2013.01.28.20.33.44.918987@googlemail.com>
 <20130128204639.GB7759@google.com>
 <20130212004023.GA8427@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212004023.GA8427@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah Sharp wrote:

> Can you turn on CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING,
> recompile the 3.7.5 kernel, and send me dmesg starting from the point
> you unmount the device and then power it off?
>
> I'd like to keep that patch in stable, but I need to understand what
> exactly is failing with it.

Note that Holger ran into the same problem using a mainline (3.8-rc5)
kernel.

Thanks,
Jonathan
