Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3EVGtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:49:16 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1046 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3EVGtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:49:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 0/4] media: remove duplicate check for EPERM
Date: Wed, 22 May 2013 08:47:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc5-tschai; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, ivtv-devel@ivtvdriver.org,
        linux-kernel@vger.kernel.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Andy Walls <awalls@md.metrocast.net>,
        Mike Isely <isely@pobox.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Antti Palosaari <crope@iki.fi>,
        Jon Arne =?iso-8859-1?q?J=F8rgensen?= <jonarne@jonarne.no>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexey Klimov <klimov.linux@gmail.com>,
        Martin Bugge <marbugge@cisco.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Frank =?iso-8859-1?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
        Janne Grunau <j@jannau.net>
References: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8s9-n2nEpbT97StctRL5jU=9hLF_d4p5bKCJx93uSUxrA@mail.gmail.com>
In-Reply-To: <CA+V-a8s9-n2nEpbT97StctRL5jU=9hLF_d4p5bKCJx93uSUxrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305220847.05588.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 22 2013 07:52:03 Prabhakar Lad wrote:
> Hi All,
> 
> On Tue, May 14, 2013 at 11:15 AM, Lad Prabhakar
> <prabhakar.csengg@gmail.com> wrote:
> > From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >
> > This patch series cleanups the check for EPERM in dbg_g/s_register
> > and vidioc_g/s_register.
> >
> > Lad, Prabhakar (4):
> >   media: i2c: remove duplicate checks for EPERM in dbg_g/s_register
> >   media: dvb-frontends: remove duplicate checks for EPERM in
> >     dbg_g/s_register
> >   media: usb: remove duplicate checks for EPERM in vidioc_g/s_register
> >   media: pci: remove duplicate checks for EPERM
> >
> Gentle ping..

For the record: it's in my queue and I plan on merging this on Friday.

Regards,

	Hans
