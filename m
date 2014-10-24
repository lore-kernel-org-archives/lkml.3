Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaJXHPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:15:38 -0400
Received: from axentia.se ([87.96.186.132]:37379 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaJXHPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:15:37 -0400
From: Peter Rosin <peda@axentia.se>
To: Bo Shen <voice.shen@atmel.com>
CC: "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, "Mark Brown" <broonie@kernel.org>
Subject: RE: [PATCH v2] ASoC: atmel_ssc_dai: Match the CMR divider only in
 full duplex.
Thread-Topic: [PATCH v2] ASoC: atmel_ssc_dai: Match the CMR divider only in
 full duplex.
Thread-Index: AQHP7ziz2ogCrWKxrES4V3qMqZZNsJw+1JMg
Date: Fri, 24 Oct 2014 07:13:47 +0000
Message-ID: <6496d69edfbf49ad81b068b259e98479@EMAIL.axentia.se>
References: <5733bb4302d148feb0bbd8ffd8c054a2@EMAIL.axentia.se>
 <5449C437.30309@atmel.com>
In-Reply-To: <5449C437.30309@atmel.com>
Accept-Language: en-US, sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.210.101.82]
x-gfi-smtp-submission: 1
x-gfi-smtp-hellodomain: EMAIL.axentia.se
x-gfi-smtp-remoteip: 192.168.2.5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Peter,
>    Thanks for your patch.

And thanks for the Ack!

>    Btw, do you use "git send-email" command to send the patch?

No, I  didn't, "git format-patch" and paste into the mail body. Was there some
whitespace issues with the patch?

Cheers,
Peter

