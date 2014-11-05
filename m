Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaKEPc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:32:26 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42691 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754485AbaKEPcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:32:23 -0500
Date: Wed, 5 Nov 2014 16:32:20 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 01/15] [media] Move mediabus format definition to a more
 standard place
Message-ID: <20141105163220.6cd9ea21@bbrezillon>
In-Reply-To: <20141105150025.GS3136@valkosipuli.retiisi.org.uk>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
	<1415094910-15899-2-git-send-email-boris.brezillon@free-electrons.com>
	<5458A878.3010809@cisco.com>
	<20141104114503.309cb54f@bbrezillon>
	<5458B407.6050701@cisco.com>
	<20141105150025.GS3136@valkosipuli.retiisi.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 17:00:25 +0200
Sakari Ailus <sakari.ailus@iki.fi> wrote:

> Hi,
> 
> On Tue, Nov 04, 2014 at 12:09:59PM +0100, Hans Verkuil wrote:
> > Well, I gave two alternatives :-)
> > 
> > Both are fine as far as I am concerned, but it would be nice to hear
> > what others think.
> 
> In fact I think both are good options. :-)
> 
> I'd perhaps lean towards the latter, for it has the benefit of pushing to
> use the new definitions and the old ones can be deprecated (and eventually
> removed in year 2030 or so ;)).
> 
> Either way, preprocessor macros should be used instead of an enum since that
> way it's possible to figure out at that phase whether something is defined
> or not. There is for enums, too, but it results in a compilation error...
> 

I don't get that last part :-).

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
