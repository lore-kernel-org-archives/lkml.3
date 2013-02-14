Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786Ab3BNRll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:41:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab3BNRlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:41:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 06/15] clk: export __clk_get_name
Date: Thu, 14 Feb 2013 17:41:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>, arm@kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <CAOMZO5AON+FhTQpTbEdjwZaEaxsPoEVLeALhH2s34biWH_EeOA@mail.gmail.com> <201301221543.18859.arnd@arndb.de>
In-Reply-To: <201301221543.18859.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302141741.34474.arnd@arndb.de>
X-Provags-ID: V02:K0:Z/y7yvwDcWxU0tUSTvD7g8aMyfeBGSwhPWK4LyCbIfW
 PPRR5G15NQvcUaCpTwF2bKj/GUpjG25LUXmyEPxWAygMVSxpGK
 kjvek+ezd7v+7x1Yuwnd3ivb6H+uSdxA0wfkjpucT8ln2k6Tru
 v51wGmuSIelNTD5DKuYX/8/M971s5inlvAUdl1944CYv0XgLnz
 0yfMvsA5EAPx3GZsb9nIqrMmtz+LKOg1rn1Qh0HUaPTT6sXQY2
 b5maMoUeBLwzXmSUembKphVODDE39KM/Jy066aY5flSnxtgbUw
 X+wnuP3MkhkN4JUsPsn1o1Ed8Rpg078BRdsUThwCR9Uoia/WT0
 q0BU800xrO3S4RPl1dXc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Arnd Bergmann wrote:
> On Tuesday 22 January 2013, Fabio Estevam wrote:
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > > Cc: Mike Turquette <mturquette@linaro.org>
> > 
> > A fix from Niels de Vos has already been applied into clk-next:
> > https://patchwork.kernel.org/patch/1871981/
> 
> Ok, very good. Mike, I saw that the patch is over
> a month old. Any reason it hasn't made it into v3.8.rc yet?
> 

I guess we missed this one for 3.8 then, meaning we have no
working allmodconfig :(

	Arnd
