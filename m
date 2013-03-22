Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538Ab3CVPVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:21:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3CVPVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:21:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 0/4] dw_dmac: cleanup for DT usage
Date: Fri, 22 Mar 2013 15:20:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>
References: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221520.54322.arnd@arndb.de>
X-Provags-ID: V02:K0:j7+EsD0xtE5XgEjbjjKDo/byK/J6ZnZcruSkJMW22Nw
 7YWSac42t53FNlV/h95Dc+oPQhj6AmhQJ9Hf063dzYJlatEC15
 6OT6l4WCgnlazgihO18EjNBCwzm4qfkJyCithvpDraT9y9ocaW
 bS4OlQxsTq+oNjggdy75m2Yu6Omc8/RGC+bGTvf3WclWbRWB9J
 llNLoyG0LmlIudkOm0yIKp89npM/Tf54NF7tLC4YTGbcXXslq6
 qfNBnu6otDHHc2mtQSV9eSow24BxwoalibsnqoIzp06+3QDWd8
 mfTW/lRO3Ajc3tF7SPoPVS1i5gWhtJsmnwIP/UzjQmCbyGcSxj
 ZwAre8ODYFp11n5dp0m0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 March 2013, Andy Shevchenko wrote:
> It includes few cleanups when used with DT. Patch 4/4 is a modified version of
> the [1].
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg225366.html
> 
> Andy Shevchenko (3):
>   dw_dmac: fix style of the comments
>   dw_dmac: rename DT related methods to reflect their belonging
>   dw_dmac: make build of DT related methods optional
> 
> Arnd Bergmann (1):
>   dmaengine: dw_dmac: simplify master selection
> 

Thanks for following up on this!

The first two patches look good to me, but I think the third one is not
needed, since the interface was meant to work without the need for #ifdef
hacks in drivers.

	Arnd
