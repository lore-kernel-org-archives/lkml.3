Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaKCB0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 20:26:14 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:59755 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaKCB0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 20:26:13 -0500
Message-ID: <5456D989.8000108@atmel.com>
Date: Mon, 3 Nov 2014 09:25:29 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Peter Rosin <peda@axentia.se>
CC: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: atmel_ssc_dai: Match the CMR divider only in full
 duplex.
References: <544A1121.6080900@atmel.com> <1414178759-7252-1-git-send-email-peda@axentia.se> <1414178759-7252-2-git-send-email-peda@axentia.se> <20141031181210.GQ18557@sirena.org.uk>
In-Reply-To: <20141031181210.GQ18557@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 11/01/2014 02:12 AM, Mark Brown wrote:
> On Fri, Oct 24, 2014 at 09:25:59PM +0200, Peter Rosin wrote:
>> The CMR divider register is shared by playback and capture. The SSC driver
>> therefore tries to enforce rules so that the needed register content do
>> not conflict during simultaneous playback/capture. However, the
>> implementation also prevents changing the register content in
>> half-duplex scenarios, which is needed when using the OSS API.
>
> Bo, is this OK?

I have acked this patch. However Peter resend with "git send-email" 
command while not add Acked-by tag. Anyway:

Acked-by: Bo Shen <voice.shen@atmel.com>

Best Regards,
Bo Shen

