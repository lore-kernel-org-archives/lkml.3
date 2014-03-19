Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaCSSvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:51:14 -0400
Received: from smtp-out-002.synserver.de ([212.40.185.2]:1053 "EHLO
	smtp-out-242.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750812AbaCSSvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:51:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9279
Message-ID: <5329E749.6070900@metafoo.de>
Date: Wed, 19 Mar 2014 19:51:53 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jyri Sarha <jsarha@ti.com>
CC: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        Xiubo Li <Li.Xiubo@freescale.com>, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH v3 4/4] ASoC: simple-card: Add DT documentation
 for multi-DAI links
References: <cover.1394883134.git.moinejf@free.fr>	<d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr>	<20140317164339.GR11706@sirena.org.uk> <20140318091728.1d2240ca@armhf> <53296CB7.1000909@ti.com>
In-Reply-To: <53296CB7.1000909@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 11:08 AM, Jyri Sarha wrote:
[...]
> It may sometimes be helpful to allow overwriting link level settings in dai
> level. In order to do that it should be possible to write all daifmt
> settings explicitly like this:
>
> bitclock-inversion = <0>; /* <0> = no bitclock-inversion */

When does this make sense? Either the bitclock is inverted for all of them 
or for none.

