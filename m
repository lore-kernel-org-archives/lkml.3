Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963Ab3GESNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 14:13:04 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:61822 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3GESNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 14:13:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130705180603.GG27646@sirena.org.uk>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
 <1372667978-4718-9-git-send-email-richard.genoud@gmail.com>
 <51D2472B.2010407@atmel.com> <CACQ1gAji8KkjXee8o=9jt8O38611LBJ95yXimxbfn1qLaLOcnA@mail.gmail.com>
 <20130705180603.GG27646@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 5 Jul 2013 20:12:40 +0200
Message-ID: <CACQ1gAjCEta_E2XyGmfLWwNi4ff14HHwUPDFPbL4Fhcc_hnRsQ@mail.gmail.com>
Subject: Re: [RFC PATCH 08/13] sound: sam9x5_wm8731: machine driver for
 at91sam9x5 wm8731 boards
To: Mark Brown <broonie@kernel.org>
Cc: Bo Shen <voice.shen@atmel.com>, devicetree-discuss@lists.ozlabs.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/5 Mark Brown <broonie@kernel.org>:
> On Fri, Jul 05, 2013 at 05:15:05PM +0200, Richard Genoud wrote:
>> 2013/7/2 Bo Shen <voice.shen@atmel.com>:
>
>> >> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>> >>
>> >> Description of the Asoc machine driver for an at91sam9x5 based board
>> >> with a wm8731 audio DAC. Wm8731 is clocked by a crystal and used as a
>> >> master on the SSC/I2S interface. Its connections are a headphone jack
>> >> and an Line input jack.
>
> Always CC relevant maintainers and mailing lists on patches...
Sorry Mark, I'll double check that on the next version.

Thanks !

Best Regards,
Richard.
