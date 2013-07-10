Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3GJJdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:33:05 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58617 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3GJJdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:33:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130709150114.GB27646@sirena.org.uk>
References: <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-1-git-send-email-richard.genoud@gmail.com>
 <1373379933-32749-3-git-send-email-richard.genoud@gmail.com> <20130709150114.GB27646@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 10 Jul 2013 11:32:42 +0200
Message-ID: <CACQ1gAjxWYVrOM8wvq7emArO7s_bion-ZgnB9tx3DN5htoV2qw@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] Documentation: DT: add sam9x5ek-wm8731 machine driver
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/9 Mark Brown <broonie@kernel.org>:
> On Tue, Jul 09, 2013 at 04:25:28PM +0200, Richard Genoud wrote:
>> This add the sound DT binding for sam9x5ek-wm8731 machine driver
>>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>> ---
>>  .../bindings/sound/atmel-sam9x5-wm8731-audio.txt   |   30 ++++++++++++++++++++
>
> Put new binding documents in the same patch that reads them, this makes
> review easier.
ok, I'll squash it with patch 1

>> +  - atmel,audio-routing: A list of the connections between audio components.
>
> This needs to be more specific and list the available board specific
> nodes for routing.  For the CODEC you can just refer to the CODEC
> binding documentation.
Ok, I'll do that.

>> +  - atmel,format: DAI format. Must be "i2s"
>
> So why not just omit this then?
Will be removed.

>
>> +  - atmel,bitclock-master:  DAI clock master
>> +  - atmel,frame-master: DAI frame master
>
> The driver isn't handling these and there's no information on how to set
> them.
They will also go away.


Thanks !
