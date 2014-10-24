Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaJXIqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:46:34 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:17825 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaJXIqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:46:32 -0400
Message-ID: <544A11E1.20307@atmel.com>
Date: Fri, 24 Oct 2014 16:46:25 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Rosin <peda@axentia.se>
CC: "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, "Mark Brown" <broonie@kernel.org>
Subject: Re: [PATCH v2] ASoC: atmel_ssc_dai: Match the CMR divider only in
 full duplex.
References: <5733bb4302d148feb0bbd8ffd8c054a2@EMAIL.axentia.se> <5449C437.30309@atmel.com> <6496d69edfbf49ad81b068b259e98479@EMAIL.axentia.se>
In-Reply-To: <6496d69edfbf49ad81b068b259e98479@EMAIL.axentia.se>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 10/24/2014 03:13 PM, Peter Rosin wrote:
>> Hi Peter,
>>     Thanks for your patch.
>
> And thanks for the Ack!
>
>>     Btw, do you use "git send-email" command to send the patch?
>
> No, I  didn't, "git format-patch" and paste into the mail body. Was there some
> whitespace issues with the patch?

If you paste patch into the mail body, after using "git am" to apply 
your patch, git log will show like:
--->8---
commit bfb9419839caeca07aa3e99c141fc7c1ac4f37af
Author: Peter Rosin <peda@axentia.se>
Date:   Wed Oct 22 15:13:55 2014 +0000

     ASoC: atmel_ssc_dai: Match the CMR divider only in full duplex.

     From 86be84c4de4e7b21cfda9656a02a902c543210af Mon Sep 17 00:00:00 2001
     From: Peter Rosin <peda@axentia.se>
     Date: Wed, 22 Oct 2014 16:45:29 +0200
     Subject: [PATCH v2] ASoC: atmel_ssc_dai: Match the CMR divider only 
in full
      duplex.

     The CMR divider register is shared by playback and capture. The SSC 
driver
     therefore tries to enforce rules so that the needed register content do
     not conflict during simultaneous playback/capture. However, the
     implementation also prevents changing the register content in
     half-duplex scenarios, which is needed when using the OSS API.
---8<---

If you use "git send-email", after using "git am" to apply your patch, 
git log will show like:
--->8---
commit bfb9419839caeca07aa3e99c141fc7c1ac4f37af
Author: Peter Rosin <peda@axentia.se>
Date:   Wed Oct 22 15:13:55 2014 +0000

     ASoC: atmel_ssc_dai: Match the CMR divider only in full duplex.

     The CMR divider register is shared by playback and capture. The SSC 
driver
     therefore tries to enforce rules so that the needed register content do
     not conflict during simultaneous playback/capture. However, the
     implementation also prevents changing the register content in
     half-duplex scenarios, which is needed when using the OSS API.
---8<---

> Cheers,
> Peter
>

Best Regards,
Bo Shen
