Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbaAGCkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:40:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbaAGCke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:40:34 -0500
Date: Mon, 6 Jan 2014 18:40:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?5rKI5YWJ?= <shenguang10@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb:hub set hub->change_bits when over-current happens
Message-ID: <20140107024050.GA8903@kroah.com>
References: <CANthSfZij7=q1azM1wrRNDWjFY972zFpe4njBKr3bzUVsm5m-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANthSfZij7=q1azM1wrRNDWjFY972zFpe4njBKr3bzUVsm5m-Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 10:33:14AM +0800, 沈光 wrote:
> set hub->change_bits when we plug in a device which causes
> over-current condition, so that hub_events() will check it.

Why?

What does this solve?  Is this a bug with existing devices that needs to
be backported to older kernels?

thanks,

greg k-h
