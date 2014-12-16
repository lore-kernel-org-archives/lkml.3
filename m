Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaLPO1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:27:49 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45788 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaLPO1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:27:48 -0500
MIME-Version: 1.0
In-Reply-To: <54903E88.2070701@collabora.com>
References: <CAL8zT=hAVi2-io3POmj9Lp1AF11ovg6bqCMPRp_w_QySAgFGtw@mail.gmail.com>
 <548F272E.3040808@gmail.com> <548F2DD6.70805@collabora.com>
 <CAL8zT=jNis3VN11xN82fci5dA5f0TwAAhkBVq2+5TaKpmm_S-Q@mail.gmail.com>
 <1418736635.3374.64.camel@pengutronix.de> <54903E88.2070701@collabora.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Tue, 16 Dec 2014 15:27:32 +0100
X-Google-Sender-Auth: E_IPlb1RfV52WX0Y1h6g5IWIKHc
Message-ID: <CAL8zT=hq5mx71eB8dBea2qAuESjcLYremb81Vj-BjjTd+iA2-g@mail.gmail.com>
Subject: Re: i.MX6 CSC and scaler
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-12-16 15:15 GMT+01:00 Nicolas Dufresne <nicolas.dufresne@collabora.com>:
>
> Le 2014-12-16 08:30, Philipp Zabel a écrit :
>>
>> For the IPU IC mem2mem scaler/CSC, v4l2transform with scaling capability
>> would be the perfect fit
>
> Thanks you for clarifying. Jean-Michel, are you going to work on this ? If
> so, feel free to contact me directly for pointers. You'll find me as stormer
> on IRC freenode on both #v4l2 and #gstreamer.

Well, yes, we are going to work on it, but first we need to have
Steve's module probed. It seems to be using DT, but figuring out how
to use it properly.

> What would need to be done:
> a) Import scaler negotiation code from videoscale element, and merge it into
> v4l2transform negotiation. It is likely that wtay (Wim Tayman) have some
> code already for you, has on the SW side he is currently working on merging
> videoscale and videoconvert together as it's faster this way.

OK, so better to go on #gstreamer and talk together with Wim of this.

> b) Complete the handling of G_CROP (if required add G_SELECTION). Most HW
> scaler will allocate aligned buffers, but can reach a 1 or 2 pixels
> precision through CROP or SELECTION.

Have you already started something about that ?
JM
