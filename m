Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaAKS65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:58:57 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34581 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751274AbaAKS6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:58:55 -0500
Date: Sat, 11 Jan 2014 18:58:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/28] drm/i2c: tda998x: add DT support and other
	improvements
Message-ID: <20140111185850.GM15937@n2100.arm.linux.org.uk>
References: <20140109115651.482e2db1@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109115651.482e2db1@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:56:51AM +0100, Jean-Francois Moine wrote:
> This patch set contains various extensions to the tda998x driver:
> 
> - simplify the i2c read/write
> - code cleanup and fix some small errors
> - use HDMI constants
> - don't read write-only registers
> - add DT support
> - use irq for connection status and EDID read
> - get a better status of the HDMI connector
> - use the tda998x video format when cea mode
> - add tda998x codec interface
> 
> - v2
> 	- decompose patches with different topics
> 	- fix some bad i2c register values
> 	- add audio codec interface
> 

Next time you post patches, please ensure that each patch is a reply
to your series covering message, so that they can be easily threaded
together.  It's a pain to have to search around for all the individual
patches amongst other people's traffic.

Thanks.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
