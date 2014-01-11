Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaAKSQE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:16:04 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34509 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751072AbaAKSQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:16:00 -0500
Date: Sat, 11 Jan 2014 18:15:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 14/28] drm/i2c: tda998x: get a better status of the
	connexion
Message-ID: <20140111181556.GC15937@n2100.arm.linux.org.uk>
References: <20140109120428.1ea7ec3a@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120428.1ea7ec3a@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:04:28PM +0100, Jean-Francois Moine wrote:
> This patch refines the connexion status testing both bits RXSENS and
> HPD of the CEC register giving the connexion level.

In English, it's spelt "connection" - there is no x, despite it sounding
like there is.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
