Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaBDNX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:23:29 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45627 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaBDNXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:23:24 -0500
Date: Tue, 4 Feb 2014 13:22:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Landley <rob@landley.net>, LKML <linux-kernel@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 34/52] devices.txt: add video4linux device for Software
 Defined Radio
Message-ID: <20140204132256.7e829f9a@www.etchedpixels.co.uk>
In-Reply-To: <20140204111903.5c2e928e@samsung.com>
References: <20140204111903.5c2e928e@samsung.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Feb 2014 11:19:03 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:

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

Acked-by: Alan Cox <alan@linux.intel.com>
