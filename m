Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161749AbaDPPeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:34:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22627 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbaDPPeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:34:23 -0400
Date: Wed, 16 Apr 2014 18:33:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Intel: Fix incorrect sizeof() in
 sst_hsw_stream_get_volume()
Message-ID: <20140416152815.GG4963@mwanda>
References: <20140413195636.32f31cb2@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413195636.32f31cb2@spike>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 07:56:36PM +0200, Christian Engelmayer wrote:
> Fix an incorrect sizeof() usage in sst_hsw_stream_get_volume(). sst_dsp_read()
> is called to read into a variable of type u32, but is passed sizeof(u32 *) for
> argument 'size_t bytes'. Detected by Coverity: CID 1195260.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

There are a couple others in this file.  I introduced one of them.  :(
Sorry about that.  I'll send a patch for that.

regards,
dan carpenter

