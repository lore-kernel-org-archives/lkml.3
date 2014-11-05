Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbaKEPCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:02:15 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51869 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754978AbaKEPA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:00:59 -0500
Date: Wed, 5 Nov 2014 17:00:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 01/15] [media] Move mediabus format definition to a more
 standard place
Message-ID: <20141105150025.GS3136@valkosipuli.retiisi.org.uk>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415094910-15899-2-git-send-email-boris.brezillon@free-electrons.com>
 <5458A878.3010809@cisco.com>
 <20141104114503.309cb54f@bbrezillon>
 <5458B407.6050701@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5458B407.6050701@cisco.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 04, 2014 at 12:09:59PM +0100, Hans Verkuil wrote:
> Well, I gave two alternatives :-)
> 
> Both are fine as far as I am concerned, but it would be nice to hear
> what others think.

In fact I think both are good options. :-)

I'd perhaps lean towards the latter, for it has the benefit of pushing to
use the new definitions and the old ones can be deprecated (and eventually
removed in year 2030 or so ;)).

Either way, preprocessor macros should be used instead of an enum since that
way it's possible to figure out at that phase whether something is defined
or not. There is for enums, too, but it results in a compilation error...

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
