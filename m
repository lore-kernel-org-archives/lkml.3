Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaAKRLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:11:37 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34308 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751345AbaAKRLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:11:35 -0500
Date: Sat, 11 Jan 2014 17:11:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 7/28] drm/i2c: tda998x: set the video mode from the
	adjusted value
Message-ID: <20140111171130.GT15937@n2100.arm.linux.org.uk>
References: <20140109115903.00517f15@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109115903.00517f15@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:59:03AM +0100, Jean-Francois Moine wrote:
> This patch uses always the adjusted video mode instead of a mix of
> original and adjusted mode.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

No visible side effects here, but rather than copying the "adjusted_mode"
pointer to "mode", I'd much rather see the references to "mode" become
"adjusted_mode" instead - choose a shorter name if it's too long, maybe
"adj_mode" ?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
