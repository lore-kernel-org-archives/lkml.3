Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab3HNOfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:35:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41606 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960Ab3HNOf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:35:28 -0400
Date: Wed, 14 Aug 2013 15:35:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] drm/i2c: tda998x: fix sync generation and
	calculation
Message-ID: <20130814143513.GA31161@n2100.arm.linux.org.uk>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375741218-10225-7-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375741218-10225-7-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 12:20:16AM +0200, Sebastian Hesselbarth wrote:
> This fixes the wrong sync generation and sync calculation of TDA998x
> for HS/VS-based sync detection.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

The plus point with this is that interlaced modes (1080i) do work with
the TDA998x again, so I think that the vertical calculations are
probably correct.
