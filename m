Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3ETM01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:26:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3ETM00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:26:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [RFC PATCHv3 3/6] clk: Add TI-Nspire clock drivers
Date: Mon, 20 May 2013 14:26:30 +0200
Message-ID: <4603632.xLpXUpmrfP@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <C574C0B3-194E-451A-8584-A351D85C5792@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <201305192148.46398.arnd@arndb.de> <C574C0B3-194E-451A-8584-A351D85C5792@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nUvrCxbcAj/2021xrRm+7WL9YvC+8gH1Atn9kkxOUUx
 /bkdwpW+8AgRo43TTGrO0BkuOIRHIjlA8KwGMHL6yf0ejg1ARZ
 e5HDu+zKvYQ6McYx0PxQErk1pCK45xG5tFNH2+8ENl1ZKOFe52
 IoesFQMBPBIZ11G8Q6FgbIXaahpTThO4Uis/syX2xnpYFjoh8/
 wkWQU4XcEI76tFb4qcCfMS6R7PoJ6zjcr6L2eJ7TgfkRM7IMiZ
 9RCnlCAmGP76E4JZY8FgM7D/dSKDNUnmpqwVcVfxf9yggx9t1Z
 rHCm4Vz046I1N85U+w5mmpsZWjjbDRyL9TPmqSjmw9PyL9Qcyh
 6evixL7rYYsnp94KJzRk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 May 2013 21:19:33 Daniel Tang wrote:
> On 20/05/2013, at 5:48 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Sunday 19 May 2013, Daniel Tang wrote:
> >> If the vendors for the on-SOC components are unknown, should we just
> >> leave the compatible strings as is (i.e. "nspire-XXX")?
> > 
> > In that case, I would use the name of the company that made the SoC.
> > I believe someone mentioned it was made by LSI logic.
> 
> Yep, that's right. So "lsi,nspire-XXX" should be fine?

I wouldn't use that combination, since lsi did not make the nspire.
For anything on the LSI chip, "lsi,zevio-XXX" would be correct,
or maybe "lsi,zevio1020-XXX" for something specific to a particular
SoC variant. For off-SoC parts, "ti,nspire-XXX" would be right,
or "ti,nspire-cx-XXX" if you care about the model.

	Arnd
