Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3BZHbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:31:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab3BZHbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:31:48 -0500
Date: Tue, 26 Feb 2013 08:31:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Media: remove incorrect __init/__exit markups
In-Reply-To: <20130226071726.GA11322@core.coreip.homeip.net>
Message-ID: <Pine.LNX.4.64.1302260829330.15531@axis700.grange>
References: <20130226071726.GA11322@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:7uVHUkzHdh1cq6YsCUAC4/QyVu2uwHVdOk/Zlm218do
 CDNvgtTM/9Rmn6C9QPc31y7+1FiZlI4BCDv1zKRi7aG6WOdFMZ
 +zyhWd4U0v/KR8uEHmU4xJ5QHINUjyJSCXjudNISyeg9U4y22p
 YW3bbCEPeoReqxupwkvt9AXvxhyL1H0klyrepcVyiQca1VRzMo
 vztKJYoDdqpMTeVX2cTwSudBpUVgS4mgbHmarBwguZsWwSu8ND
 fv6y2KpJAKBo+BaUAKchc0/46LuZwUzsYtj0OxeDeZa06Rq6as
 q+MTpHKYPdrrk/6WDBkn9gNDGoYaYRkaA0e2zmsoe69EafGVmr
 T1E4a8y15YVdUXF1jhB1Lzh0UQxlAEpDkkYaAHOrpCjd+s57c5
 0xtnQtam1ccJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013, Dmitry Torokhov wrote:

> Even if bus is not hot-pluggable, the devices can be unbound from the
> driver via sysfs, so we should not be using __exit annotations on
> remove() methods. The only exception is drivers registered with
> platform_driver_probe() which specifically disables sysfs bind/unbind
> attributes.
> 
> Similarly probe() methods should not be marked __init unless
> platform_driver_probe() is used.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
> v1->v2: removed __init markup on omap1_cam_probe() that was pointed out
> 	by Guennadi Liakhovetski.
> 
>  drivers/media/platform/soc_camera/omap1_camera.c | 6 +++---

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
