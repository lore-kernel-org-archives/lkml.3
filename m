Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaAVXwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:52:12 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45891 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753123AbaAVXwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:52:11 -0500
Date: Wed, 22 Jan 2014 23:52:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 22/24] drm/i2c: tda998x: change the frequence in the
	audio channel
Message-ID: <20140122235204.GS15937@n2100.arm.linux.org.uk>
References: <cover.1390153344.git.moinejf@free.fr> <20140119195847.646a40b0@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119195847.646a40b0@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 07:58:47PM +0100, Jean-Francois Moine wrote:
> This patch sets the frequence as 'not indicated' instead of '48kHz'
> and adds some comments.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Good catch that byte 2 doesn't exist in this set.

sound/asounddef.h has definitions for these:

IEC958_AES0_CON_NOT_COPYRIGHT
IEC958_AES3_CON_FS_NOTID
IEC958_AES4_CON_MAX_WORDLEN_24
IEC958_AES4_CON_ORIGFS_NOTID

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
