Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaBDPYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:24:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaBDPYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:24:46 -0500
Date: Tue, 4 Feb 2014 16:26:23 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Rob Landley <rob@landley.net>,
        LKML <linux-kernel@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>, Antti Palosaari <crope@iki.fi>
Subject: Re: Fw: [PATCH 34/52] devices.txt: add video4linux device for
 Software Defined Radio
Message-ID: <20140204152623.GA8556@kroah.com>
References: <20140204111903.5c2e928e@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204111903.5c2e928e@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 11:19:03AM -0200, Mauro Carvalho Chehab wrote:
> Alan/Greg/Andrew/Rob,
> 
> Not sure who is currently maintaining Documentation/devices.txt.
> 
> We're needing to add support of a new type of V4L2 devices there.
> 
> Could you please ack with the following patch? If this one is ok, I intend
> to send via my tree together with the patch series that implements support
> for it, if you agree.
> 
> Thank you!
> Mauro
> 
> Forwarded message:
> 
> Date: Sat, 25 Jan 2014 19:10:28 +0200
> From: Antti Palosaari <crope@iki.fi>
> To: linux-media@vger.kernel.org
> Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
> Subject: [PATCH 34/52] devices.txt: add video4linux device for Software Defined Radio
> 
> 
> Add new video4linux device named /dev/swradio for Software Defined
> Radio use. V4L device minor numbers are allocated dynamically
> nowadays, but there is still configuration option for old fixed style.
> Add note to mention that configuration option too.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
