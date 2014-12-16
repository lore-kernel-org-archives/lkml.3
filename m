Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083AbaLPONn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:13:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbaLPONm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:13:42 -0500
Message-ID: <54903DBE.1090100@redhat.com>
Date: Tue, 16 Dec 2014 15:12:14 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgTGFuemVuZMO2cmZlcg==?= 
	<david.lanzendoerfer@o2s.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        Peter Griffin <peter.griffin@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?B?5p2O5oOz?= <lixiang@allwinnertech.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] mmc: sunxi: General fixup (v2)
References: <20141216140921.3036.14668.stgit@dizzy-6.o2s.ch>
In-Reply-To: <20141216140921.3036.14668.stgit@dizzy-6.o2s.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16-12-14 15:10, David Lanzendörfer wrote:
> Hello
> This patchset was inspired questions from 李想 of Allwinner and incorporates as
> well suggestions from Hans related to spin locks.
> For example have not all attributes of the shared host object been protected
> by the spin lock, this has been changed.
> Also some register names and reset behavior have been fixed now.
> And a minor cleanup happened at the clock frequecy setting, since there has
> been a piece of left over code which has been there because it was in the Android
> driver and we just adapted it because we didn't have proper documentation about
> the timing of the module.
>
> Looking forward to your feedback
> Cheers David

Thanks.

Series looks good and is:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans
