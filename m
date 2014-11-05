Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaKEPIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:08:21 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52008 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754999AbaKEPIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:08:18 -0500
Date: Wed, 5 Nov 2014 17:08:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 11/15] [media] Deprecate v4l2_mbus_pixelcode
Message-ID: <20141105150814.GT3136@valkosipuli.retiisi.org.uk>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415094910-15899-12-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415094910-15899-12-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Tue, Nov 04, 2014 at 10:55:06AM +0100, Boris Brezillon wrote:
> The v4l2_mbus_pixelcode enum (or its values) should be replaced by the
> media_bus_format enum.
> Keep this enum in v4l2-mediabus.h and create a new header containing
> the v4l2_mbus_framefmt struct definition (which is not deprecated) so
> that we can add a #warning statement in v4l2-mediabus.h and hopefully
> encourage users to move to the new definitions.
> 
> Replace inclusion of v4l2-mediabus.h with v4l2-mbus.h in all common headers
> and update the documentation Makefile to parse v4l2-mbus.h instead of
> v4l2-mediabus.h.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  Documentation/DocBook/media/Makefile |  2 +-
>  include/media/v4l2-mediabus.h        |  2 +-
>  include/uapi/linux/Kbuild            |  1 +
>  include/uapi/linux/v4l2-mbus.h       | 35 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/v4l2-mediabus.h   | 26 ++++----------------------

I would keep the original file name, even if the compatibility definitions
are there. I don't see any harm in having them around as well.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
