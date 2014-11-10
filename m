Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaKJRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:25:56 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45229 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752862AbaKJRZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:25:52 -0500
Date: Mon, 10 Nov 2014 18:25:50 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v6 00/10]  [media] Make mediabus format subsystem
 neutral
Message-ID: <20141110182550.18d95bce@bbrezillon>
In-Reply-To: <1415640114-14930-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415640114-14930-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 18:21:44 +0100
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This patch series prepares the use of media bus formats outside of
> the V4L2 subsytem (my final goal is to use it in the Atmel HLCDC DRM
> driver where I have to configure my DPI/RGB bus according to the
> connected display).
> 
> The series first defines MEDIA_BUS_FMT_ macros, and then replace all
> references to the v4l2_mbus_pixelcode enum and its values within the
> kernel.
> 
> Best Regards,
> 
> Boris
> 
> Changes since v5:
> - fix V4L2_MBUS_FROM_MEDIA_BUS_FMT macro definition

Sorry for the noise, I sent the wrong patch set :-(.

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
