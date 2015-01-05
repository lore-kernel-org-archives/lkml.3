Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbbAEPJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:09:17 -0500
Received: from mx0b-001ae601.pphosted.com ([67.231.152.168]:43890 "EHLO
	m0077474.ppops.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751773AbbAEPJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:09:16 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2015 10:09:16 EST
Date: Mon, 5 Jan 2015 09:05:27 -0600
From: Brian Austin <brian.austin@cirrus.com>
X-X-Sender: heelrod@heelrod
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Brian Austin <brian.austin@cirrus.com>,
        Paul Handrigan <Paul.Handrigan@cirrus.com>
Subject: Re: [PATCH 2/8] ASoC: cs35l32: Constify struct regmap_config and
 snd_soc_codec_driver
In-Reply-To: <1420449508-10701-2-git-send-email-k.kozlowski@samsung.com>
Message-ID: <alpine.DEB.2.10.1501050904500.13892@heelrod>
References: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com> <1420449508-10701-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-05_03:2015-01-05,2015-01-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1501050157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const. Make struct
> snd_soc_codec_driver const as well (snd_soc_register_codec() accepts
> pointer to const).
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Brian Austin <brian.austin@cirrus.com>
> Cc: Paul Handrigan <Paul.Handrigan@cirrus.com>
For the Cirrus Codecs

Acked-by: Brian Austin <brian.austin@cirrus.com>

Thanks 
