Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3KAKA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:00:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38672 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459Ab3KAKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:00:57 -0400
Date: Fri, 1 Nov 2013 10:00:52 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Subject: [PATCH 0/2] wm8962: Add ALC and EQ coefficients
Message-ID: <20131101100051.GA1901@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches to expose the coefficient blocks for the
ALC and EQ filters.

Richard Fitzgerald (2):
  ASoC: wm8962: Add ALC coefficient support
  ASoC: wm8962: Add EQ coefficient support

 sound/soc/codecs/wm8962.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

-- 
1.7.2.5

