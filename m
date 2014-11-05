Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbaKEPX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:23:28 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52222 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932396AbaKEPX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:23:26 -0500
Date: Wed, 5 Nov 2014 17:22:52 +0200
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
Message-ID: <20141105152252.GV3136@valkosipuli.retiisi.org.uk>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415094910-15899-12-git-send-email-boris.brezillon@free-electrons.com>
 <20141105150814.GT3136@valkosipuli.retiisi.org.uk>
 <20141105161538.7a1686d5@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105161538.7a1686d5@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Wed, Nov 05, 2014 at 04:15:38PM +0100, Boris Brezillon wrote:
> On Wed, 5 Nov 2014 17:08:15 +0200
> Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > I would keep the original file name, even if the compatibility definitions
> > are there. I don't see any harm in having them around as well.
> > 
> 
> That's the part I was not sure about.
> The goal of this patch (and the following ones) is to deprecate
> v4l2_mbus_pixelcode enum and its values by adding a #warning when
> v4l2-mediabus.h file is included, thus encouraging people to use new
> definitions.
> 
> Do you see another solution to generate such warnings at compilation
> time ?

Do you think we need a warning? In a general case we can't start renaming
interface headers once the preferred interface changes, albeit in this case
it would be a possibility.

The presence of the formats defined from now on only in the new definitions
should be good enough. There are many cases such as this in the V4L2 and
other APIs.

I wonder what others think.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
