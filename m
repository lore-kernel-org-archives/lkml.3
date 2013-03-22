Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161090Ab3CVRGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:06:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161016Ab3CVRGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:06:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Ball <cjb@laptop.org>
Subject: Re: FW: Regulator API ignored return values
Date: Fri, 22 Mar 2013 17:06:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Kevin Liu <keyuan.liu@gmail.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Axel Lin <axel.lin@ingics.com>, Jingoo Han <jg1.han@samsung.com>,
        Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        linux-mmc@vger.kernel.org
References: <25B60CDC2F704E4E9D88FFD52780CB4C0BDEB0547F@SC-VEXCH1.marvell.com> <87y5dsheqo.fsf@octavius.laptop.org> <87d2uro09v.fsf@octavius.laptop.org>
In-Reply-To: <87d2uro09v.fsf@octavius.laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221706.27733.arnd@arndb.de>
X-Provags-ID: V02:K0:VoRMZTW+OHJKTOdckN41SGfI/CXHJuevjxeuUDJLiUF
 V87WWIX+Idyv4xgRyEgCDPf7qvNaVMF9C2A234UxRgCQaWZsNU
 zpvLQepN0doPeEnTIdfz4WM37r11g0OIqnv/UHO2+zfybF4XNx
 /criAofsWR1V5hSnSuLdIN27PjuOSkZVEBrubrRrKAWpa+oSXR
 taOTWvYP6laE1D7V/XGRGJXndIvtSSQv9ax7LfFAk9DMy1YrVx
 pAiXIj8mYQfaaba5EGTRGtSHdZMBRciej7fnV1apBQs17cBu1U
 IUP/Kp8EwORjXJa+5Frv3m+H3hrCg6hDdRMOZ0VutTKaTlmFAB
 zXiZPo6KnzPy3QeVSPSU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 March 2013, Chris Ball wrote:
> >
> > The reason I didn't make it a fatal error is that this is just vqmmc
> > (responsible for moving from 3.3V to 1.8V for UHS modes), not the
> > main vmmc regulator.  We can just disable those UHS modes from the
> > capabilities on the host if vqmmc is missing, or failed to enable,
> > or doesn't support those voltages, and that's what the code does now.
> 
> I've pushed this patch to mmc-next for 3.10 now, let me know if you
> disagree.

No, it's fine. Sorry for not replying earlier.

	Arnd
