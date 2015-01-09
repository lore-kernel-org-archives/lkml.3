Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbbAIKP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:15:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60807 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbbAIKPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:15:24 -0500
Message-ID: <54AFAA29.9040803@ti.com>
Date: Fri, 9 Jan 2015 12:15:05 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 0/4] ASoC: tda998x: add a codec to the HDMI transmitter
References: <cover.1420628786.git.moinejf@free.fr> <54AE99D0.1050205@ti.com> <20150108200526.GD2634@sirena.org.uk>
In-Reply-To: <20150108200526.GD2634@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 10:05 PM, Mark Brown wrote:
> On Thu, Jan 08, 2015 at 04:53:04PM +0200, Jyri Sarha wrote:
>
>> BTW, the HDMI codec is now completely unused, since my OMAP4+ HDMI audio
>> patches were merged (it uses dummy codec) and my BBB HDMI audio patches were
>> never merged.
>
> Might those BBB ones turn up sometime?
>

My intention is to take Jean-Francoises patches into use (I am currently 
working on it). I abandon my generic hdmi codec for now.
In any case I should not need the dummy HDMI codec for anything.

Best regards,
Jyri
