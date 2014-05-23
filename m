Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaEWMCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:02:47 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:48992 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaEWMCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140523114113.GE12304@sirena.org.uk>
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
	<1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
	<20140522103039.GD12304@sirena.org.uk>
	<CAHbNUh2QHv8n7Y19qfO7BagX5AWe0i17MjDvr7yOpHf6YNGW4A@mail.gmail.com>
	<20140523111446.GA12304@sirena.org.uk>
	<CAHbNUh152xgyVxcCHiv0M6PLw8DE7KZ990WG7uRWWFBc8sPWRQ@mail.gmail.com>
	<20140523114113.GE12304@sirena.org.uk>
Date: Fri, 23 May 2014 17:32:45 +0530
Message-ID: <CAHbNUh2P7gdYPSdNRx8QbxuSc9n38yq3D_TWX2jdkcpE1_N8Rw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ASoC: max98090: Add master clock handling
From: Tushar Behera <tushar.behera@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linux-ALSA <alsa-devel@alsa-project.org>,
        lkml <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Doug Anderson <dianders@chromium.org>,
        "jerry.wong" <jerry.wong@maximintegrated.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2014 17:11, Mark Brown <broonie@kernel.org> wrote:
> On Fri, May 23, 2014 at 05:06:27PM +0530, Tushar Behera wrote:
>> On 23 May 2014 16:44, Mark Brown <broonie@kernel.org> wrote:
>
>> > Should be clk_prepare_enable() and similarly for the disable and you
>> > should check the error codes but yes, that looks good.
>
>> I was planning to keep clk_prepare/clk_unprepare in probe/remove.
>
> Why - what purpose would it serve to leave the clock prepared but not
> enabled?

I was getting some kernel slow path warning initially while preparing
this code, but not able to reproduce that warning now.

-- 
Tushar Behera
