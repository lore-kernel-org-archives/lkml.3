Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaKCQL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:11:57 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39037 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaKCQLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:11:55 -0500
Message-ID: <5457A93F.70308@collabora.co.uk>
Date: Mon, 03 Nov 2014 17:11:43 +0100
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
Subject: Re: [PATCH v4 03/14] regulator: of: Add regulator desc param to of_get_regulator_init_data()
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk> <1415025649-8119-4-git-send-email-javier.martinez@collabora.co.uk> <20141103153303.GQ3815@sirena.org.uk> <5457A3D2.1090602@collabora.co.uk> <20141103155909.GX3815@sirena.org.uk>
In-Reply-To: <20141103155909.GX3815@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 04:59 PM, Mark Brown wrote:
> No, it's only *currently* used for that.  If we don't bother passing the
> descriptor in then future additions which make use of it (including
> adding mode operations to existing drivers) won't work and it might not
> be obvious why.
>

fair enough.
 
> You're already going through and modifying every single driver and all
> of those I looked at already had references to the descriptor in
> adjacent code or a global descriptor for the one regulator supported by
> the driver.
> 

Ok, I'll make sure that all drivers passes the descriptor.

Best regards,
Javier
