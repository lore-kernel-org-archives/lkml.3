Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3GIJqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:46:24 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63468 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3GIJqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:46:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130709093254.GP27646@sirena.org.uk>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373290193-25300-3-git-send-email-richard.genoud@gmail.com>
 <20130708150756.GL27646@sirena.org.uk> <CACQ1gAgnRBr6Eu7sgbzNF2kmm18-zn_dGKZN45RaxXGd1kwL-Q@mail.gmail.com>
 <20130709093254.GP27646@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 9 Jul 2013 11:46:03 +0200
Message-ID: <CACQ1gAhNAnyfaDSCxqAv11KZA2bGTdcfgcBjprAu3Ecw1y02mg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] ARM: AT91: DTS: sam9x5: add SSC DMA parameters
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/9 Mark Brown <broonie@kernel.org>:
> On Tue, Jul 09, 2013 at 10:27:53AM +0200, Richard Genoud wrote:
>
>> The dma binding is documented here
>> Documentation/devicetree/bindings/dma/atmel-dma.txt
>> But you're right, I shoud update
>> Documentation/devicetree/bindings/misc/atmel-ssc.txt.
>
> No, you need to write a binding for this machine driver - the DMA and
> SSC need to be documented as well but so too does the audio driver that
> pulls them together with the CODEC.
Ok, I understand !

Richard.
