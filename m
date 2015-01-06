Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbbAFM2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:28:23 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43227 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754172AbbAFM2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:28:22 -0500
Date: Tue, 6 Jan 2015 13:27:51 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: Bo Shen <voice.shen@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] ASoC: sam9g20_wm8731: drop machine_is_xxx
Message-ID: <20150106122751.GO4194@piout.net>
References: <1420542872-10015-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20150106120049.GX2634@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106120049.GX2634@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/01/2015 at 12:00:49 +0000, Mark Brown wrote :
> On Tue, Jan 06, 2015 at 12:14:32PM +0100, Alexandre Belloni wrote:
> > Atmel based boards can now only be used with device tree. Drop non DT
> > initialization.
> 
> This doesn't apply against current code, please check and resend.

It should apply after "sound: soc: atmel sam9g20_wm8731: remove useless
include". I was based on 3.19-rc2.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
