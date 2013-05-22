Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab3EVFw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:52:27 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:46953 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3EVFwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:52:24 -0400
MIME-Version: 1.0
In-Reply-To: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 22 May 2013 11:22:03 +0530
Message-ID: <CA+V-a8s9-n2nEpbT97StctRL5jU=9hLF_d4p5bKCJx93uSUxrA@mail.gmail.com>
Subject: Re: [PATCH 0/4] media: remove duplicate check for EPERM
To: LMML <linux-media@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, ivtv-devel@ivtvdriver.org
Cc: linux-kernel@vger.kernel.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Andy Walls <awalls@md.metrocast.net>,
        Mike Isely <isely@pobox.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Antti Palosaari <crope@iki.fi>,
        =?ISO-8859-1?Q?Jon_Arne_J=F8rgensen?= <jonarne@jonarne.no>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexey Klimov <klimov.linux@gmail.com>,
        Martin Bugge <marbugge@cisco.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
        Janne Grunau <j@jannau.net>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Tue, May 14, 2013 at 11:15 AM, Lad Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> This patch series cleanups the check for EPERM in dbg_g/s_register
> and vidioc_g/s_register.
>
> Lad, Prabhakar (4):
>   media: i2c: remove duplicate checks for EPERM in dbg_g/s_register
>   media: dvb-frontends: remove duplicate checks for EPERM in
>     dbg_g/s_register
>   media: usb: remove duplicate checks for EPERM in vidioc_g/s_register
>   media: pci: remove duplicate checks for EPERM
>
Gentle ping..

Regards,
--Prabhakar Lad
