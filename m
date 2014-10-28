Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaJ1VFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:05:55 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:64541 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaJ1VFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:05:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arm@kernel.org
Subject: Re: [PATCH] soc: versatile: Add terminating entry for realview_soc_of_match
Date: Tue, 28 Oct 2014 22:05:49 +0100
Message-ID: <2588271.FpfytU43Wu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdaTcxngj6MLGHUyx-AbB3o4iV2dtsmCCVHwacuDp=0D3A@mail.gmail.com>
References: <1413733260.6272.1.camel@phoenix> <CACRpkdaTcxngj6MLGHUyx-AbB3o4iV2dtsmCCVHwacuDp=0D3A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ayFQTu7xxu/3xwxegkpeIxotzyasWnQZ5g8WpVveNHa
 6jT8ptpiDJmpTiDxwyLHWlACs3As/gjcAg4UaG4xgIeDaOWdNk
 /OOEcVPc82KDvE7uhgwZVBaLmXpEOWQd5NaOPEah9HhQAP6U+L
 FTkXzTohvY/A4Kfv6iGY44fqYP5V31vnP1p2GU2A7fLFasW2MP
 j0YSlybOUpj5ZYeZcR0c3TdlE4SBTeqccKeWo9qAOnTlswQQJm
 SElwHvBOzZ7wNWSV69guCMMh8CwKeWbI+CqbLjS2BzWVkXJCIx
 bhlTkBLBEqdavvlIi4SI3m2PMnje8iKVNUfCVWkgYAL7CalKeK
 6DLLPSmLgZ9Z5e+dVQe4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2014 14:37:04 Linus Walleij wrote:
> On Sun, Oct 19, 2014 at 5:41 PM, Axel Lin <axel.lin@ingics.com> wrote:
> 
> > The of_device_id table is supposed to be zero-terminated.
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Arnd are you merging this directly into ARM SoC?
> 

Applied to the fixes branch.

Please remember to add arm@kernel.org when you want us to pick up the
patches.

	Arnd
