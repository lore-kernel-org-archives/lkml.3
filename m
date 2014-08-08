Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaHHSR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:17:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40826 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751002AbaHHSR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:17:57 -0400
Date: Fri, 8 Aug 2014 15:16:54 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jyri Sarha <jsarha@ti.com>
Cc: linux-kernel@vger.kernel.org, mturquette@linaro.org,
        dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        bcousson@baylibre.com, tony@atomide.com, broonie@kernel.org,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@ti.com,
        detheridge@ti.com, zonque@gmail.com, t-kristo@ti.com
Subject: Re: [PATCH 0/9] Beaglebone-Black HDMI audio
Message-ID: <20140808181654.GB16575@arch.cereza>
References: <cover.1407332062.git.jsarha@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1407332062.git.jsarha@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jyri,

On 06 Aug 04:47 PM, Jyri Sarha wrote:
> The code has a functional dependency to:
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg108199.html
> 
> Without the above patch the audio card does not probe.
> 
> The code has been rebased on top of Linux 3.16 merged with 
> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next
> with http://www.mail-archive.com/linux-omap@vger.kernel.org/msg108199.html
> cherry-picked on top.
> 
> All patches have gone trough some cleaning up since the RFC version of
> these patches over half a year ago.
> 

To my surprise, this worked out of the box. Did some simple tests with mpg123
and mplayer.

Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Thanks a lot!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
