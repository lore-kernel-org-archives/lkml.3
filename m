Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaLORDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:03:41 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:56000 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaLORDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:03:37 -0500
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Mon, 15 Dec 2014 18:03:21 +0100
X-Google-Sender-Auth: iBQMTJMdFMZHsIuR3d6nitpjozM
Message-ID: <CAL8zT=hAVi2-io3POmj9Lp1AF11ovg6bqCMPRp_w_QySAgFGtw@mail.gmail.com>
Subject: i.MX6 CSC and scaler
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve, Philipp,

I see in the kernel sources you created a ipu-ic.c file which helps
working with the Color Space Converter on i.MX6.
We would like to use it on our board with GStreamer, as the conversion
done by the CPU is not very efficient :).
What is the easiest/best approach to this ?
Should we create a video device using a new driver, which would be
instanciated as a /dev/videoX and see as a transform element in
GStreamer ?
The idea is to have a separate element, ideally without memory copy or
anything like that.

I have a similar question, regarding the scaler part. It seems to be
limited by nature to 1024x1024 frames. In FSL BSP there is a split to
have greater frames. Is there something doable right now with the
kernel, or should we write something else ?

Thanks !
JM
