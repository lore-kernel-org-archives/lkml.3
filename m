Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaKEPTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:19:40 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52158 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932293AbaKEPTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:19:38 -0500
Date: Wed, 5 Nov 2014 17:19:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 03/15] [media] Make use of the new media_bus_format
 definitions
Message-ID: <20141105151931.GU3136@valkosipuli.retiisi.org.uk>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415094910-15899-4-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415094910-15899-4-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 10:54:58AM +0100, Boris Brezillon wrote:
> Replace references to the v4l2_mbus_pixelcode enum with the new
> media_bus_format enum in all common headers.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
