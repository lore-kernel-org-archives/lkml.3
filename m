Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab3IAJ1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 05:27:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64582 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3IAJ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 05:27:03 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: "Jean-Francois Moine" <moinejf@free.fr>
CC: <linux-arm-kernel@lists.infradead.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Sun, 01 Sep 2013 11:26:54 +0200
Message-ID: <140d8d8a23f.2784.107cef0f820c2f5d7b7f41463071c310@gmail.com>
In-Reply-To: <20130831125128.0e3a23c7@armhf>
References: <20130828113521.35c53365@armhf>
 <521DCD80.9010105@gmail.com>
 <20130831125128.0e3a23c7@armhf>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1 AquaMail/1.2.4.0 (build: 2100294)
Subject: Re: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Francois,
Sorry for the messy reply, posting from mobile.

Can you please try <&si5351 1>, iirc audio ist connected to it. I will also 
look it up later.

Sebastian



On August 31, 2013 12:51:28 PM Jean-Francois Moine <moinejf@free.fr> wrote:
> On Wed, 28 Aug 2013 12:14:24 +0200
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>
> > > +&i2s1 {
> > > +	status = "okay";
> > > +	pinctrl-0 = <&pmx_audio1_i2s1_spdifo>;
> > > +	pinctrl-names = "default";
> > > +};
> > Please also add the external clock connected from si5351.
>
> Hi Sebastian and Russell,
>
> I tried it on my Cubox (<&si5351 2>), and I have problems with HDMI
> output and some audio streams like webradios with sample rates 32 or
> 22.05 kHz.
>
> According to the Dove specification, the audio controller works with
> the samples rates 44.1, 48 and 96 kHz, so, I don't see the usage of the
> external clock, except when using the two audio controllers with
> different sample rates.
>
> But, BTW, as the kirkwood-i2 driver is written, this last case does not
> work: for 44.1, 48 and 96 kHz, the external clock is never used and
> there is only one DCO.
>
> --
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/


