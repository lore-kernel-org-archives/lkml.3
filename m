Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaKCQIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:08:37 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39028 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaKCQIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:08:34 -0500
Message-ID: <5457A87A.8040508@collabora.co.uk>
Date: Mon, 03 Nov 2014 17:08:26 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 00/14] Add max77802 regulator operating mode support
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk> <20141103155443.GS3815@sirena.org.uk>
In-Reply-To: <20141103155443.GS3815@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 04:54 PM, Mark Brown wrote:
> 
> No, it's not.  This is a a patch series doing a whole bunch of different
> things, there's at least bug fixes to existing drivers, new features and
> also this new driver in what I've glanced at so far.  These things
> shouldn't just be being thrown together into a single patch series, and
> the patch series shouldn't then be described as just being what is in
> the end a minor part of the collection.
> 

Ok, sorry. Next time I'll take care to split fixes from new features and
also better explain what the series really does.

Best regards,
Javier
