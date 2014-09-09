Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbaIIN0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:26:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50328 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaIIN0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:26:18 -0400
Message-ID: <540EFFC9.4050207@ti.com>
Date: Tue, 9 Sep 2014 16:25:29 +0300
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
CC: <perex@perex.cz>, <lgirdwood@gmail.com>, <tiwai@suse.de>,
        <moinejf@free.fr>, <andrew@lunn.ch>,
        <kuninori.morimoto.gx@renesas.com>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 3/3] ASoC: simple-card: binding: update binding to support
 the new style.
References: <1409711021-19277-1-git-send-email-Li.Xiubo@freescale.com> <1409711021-19277-4-git-send-email-Li.Xiubo@freescale.com> <20140909120948.GZ2601@sirena.org.uk>
In-Reply-To: <20140909120948.GZ2601@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 03:09 PM, Mark Brown wrote:
> On Wed, Sep 03, 2014 at 10:23:41AM +0800, Xiubo Li wrote:
>> This update patch will split the DT node into old style and new style:
>> The new style will will be easier to add muti DAI links from old single
>> DAI link DTs.
>
>> This patch will maintian compatibility with the old DTs.
>
> Is everyone happy with this new style binding?
>

If I read the diff correctly the only change in the syntax is moving the 
bitclock-inversion and frame-inversion properties to DAI nodes also for 
the new style bindings.

I am Ok with that.

The document does not indicate that the same properties could be also 
placed to DAI link level like they used to, from where they would apply 
to both DAI nodes.

I am Ok with this too, but this breaks the backwards compatibility, 
which I guess is generally considered a problem. However, I doubt anyone 
but me has yet used this part of the new syntax and I am happy to fix my 
dts files.

Best regards,
Jyri

ps. I could not find the corresponding code changes in the previous 
patch, so I assume they are coming later.
