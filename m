Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaIXOia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:38:30 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41909 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:38:28 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-5c-5422d7622266
Content-transfer-encoding: 8BIT
Message-id: <1411569505.32515.0.camel@AMDC1943>
Subject: Re: [PATCH on mfd-regulator-power-v3.17] charger: max14577: Fix build
 breakage when compiled as module
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Date: Wed, 24 Sep 2014 16:38:25 +0200
In-reply-to: <20140924143519.GJ32069@lee--X1>
References: <1411560006-16471-1-git-send-email-k.kozlowski@samsung.com>
 <20140924143519.GJ32069@lee--X1>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t/xK7pJ15VCDP78UbCY+vAJm8WkJ++Z
	LSaunMxscf/rUUaLy7vmsFl87j3CaHF6d4kDu8fOWXfZPTav0PLYtKqTzePOtT1sHp83yQWw
	RnHZpKTmZJalFunbJXBlvJy8jKngBlvFojuT2BsYD7J2MXJySAiYSLS++sEEYYtJXLi3nq2L
	kYtDSGApo8Shf9eZQRK8AoISPybfY+li5OBgFpCXOHIpGyTMLKAuMWneImaI+s+MEpuPrmKH
	qNeXODO/HWyosEChxIPJs8DmsAkYS2xevoQNZI6IgIrEuTfmIL3MAncYJY6ffALWyyKgKvFs
	6X5mkBpOAV2Ji2e5QcJCAlkSf19fYQcJSwgoSzT2u01gFJiF5LhZCMfNQnLcAkbmVYyiqaXJ
	BcVJ6blGesWJucWleel6yfm5mxghof11B+PSY1aHGAU4GJV4eCeKK4UIsSaWFVfmHmKU4GBW
	EuE9egEoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgfEOS/+dZZ3St80meuR5Hb2imTCnfPf+c2vC
	fC1lw4V2ikTGfUroLnY/H1xfv8Kvd3E7w+4jllEqV5xMYiTum2q7vzly/6Du1PaF1yNrJt2x
	DpnNOUVYdUVieeAXH/7P5ZXvzlidLlaIi/o48Z5glhNLcjffvkazKy/+370jnsHwNCZr5Tcz
	RiWW4oxEQy3mouJEACpi2XhLAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-09-24 at 15:35 +0100, Lee Jones wrote:
> On Wed, 24 Sep 2014, Krzysztof Kozlowski wrote:
> 
> > The charger's module device table used the same name as regulator driver
> > causing a build break when charger was compiled as a module:
> > 
> > drivers/power/max14577_charger.c:598:1: error: ‘__mod_platform__max14577_regulator_id_device_table’ aliased to undefined symbol ‘max14577_regulator_id’
> > make[2]: *** [drivers/power/max14577_charger.o] Error 1
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > ---
> >  drivers/power/max14577_charger.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> I have fixed this up into the original set and re-sent the
> pull-request.

Great, thanks!

Best regards,
Krzysztof

