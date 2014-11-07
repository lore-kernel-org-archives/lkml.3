Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaKGWrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:47:35 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48186 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751820AbaKGWrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:47:33 -0500
Message-ID: <545D4BFD.6000206@iki.fi>
Date: Sat, 08 Nov 2014 00:47:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:33.0) Gecko/20100101 SeaMonkey/2.30
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 10/10] [media] v4l: Forbid usage of
 V4L2_MBUS_FMT definitions inside the kernel
References: <545CDB8D.4080406@xs4all.nl> <1415377630-16564-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1415377630-16564-1-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Boris Brezillon wrote:
> @@ -102,6 +113,7 @@ enum v4l2_mbus_pixelcode {
>  
>  	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
>  };
> +#endif /* __KERNEL__ */
>  
>  /**
>   * struct v4l2_mbus_framefmt - frame format on the media bus

Was it intended to be this way, or did I miss something? I'd put this to
beginning of the file, as Hans suggested.

With this matter sorted out, for the set:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
