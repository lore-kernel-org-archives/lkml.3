Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaCMJuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:50:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39085 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaCMJuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:50:15 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-98-53217f5485fe
Message-id: <1394704211.6546.3.camel@AMDC1943>
Subject: Re: [PATCH v3 4/4] mfd: max8997: move regmap handling to function
 drivers
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Thu, 13 Mar 2014 10:50:11 +0100
In-reply-to: <1394703532-494-5-git-send-email-r.baldyga@samsung.com>
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <1394703532-494-5-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t/xq7oh9YrBBqteWVgsuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi/tfjzJafLvSwWRx89M3VovLu+awWWx9s47R
	Yu2Ru+wWtxtXsFlc23uc2eLB4Z3sFrt3PWW12N/ZwWhxupvVQdhj56y77B57Jp5k89i8Qstj
	06pONo871/awecw7GeixZ/4PVo++LasYPabP+8nk8XmTnMf6LVuZArijuGxSUnMyy1KL9O0S
	uDLWzjjGXLCVraLj52PWBsbprF2MnBwSAiYSS7feYYSwxSQu3FvP1sXIxSEksJRRYv2Ux2BF
	QgKfGSUOPLTpYuTg4BXQk7i/VxAkLCwQIrFpzSJ2EJtNwFhi8/IlbCC2iICWxJ2P89lB5jAL
	HGaW2PegA2wOi4CqxIpvZ5lBbE4BF4knPzewg8wUEqiVuHVNCSTMLKAuMWneImaIe5Qkdrd3
	skPE5SU2r3kLFucVEJT4MfkeywRGgVlIWmYhKZuFpGwBI/MqRtHU0uSC4qT0XCO94sTc4tK8
	dL3k/NxNjJCI/LqDcekxq0OMAhyMSjy8AUsVgoVYE8uKK3MPMUpwMCuJ8IrVKQYL8aYkVlal
	FuXHF5XmpBYfYmTi4JRqYOz5mBe95Onck1Jbi1r7bl4LZjmzQKW9N3Gr2m1Jo7NFwbqhXo3r
	1+twH13985O3qtqtu4sS0tU/Hl2e1XCqJDlzV/L0yw/V1xlfKn6jYuG452vDyjtFIgUuS/45
	5H7/c1WN87Lw5lOPVq//3e3Od7NcMevp6g8GFQpC4Qq631+JXuN79b7noIQSS3FGoqEWc1Fx
	IgB6SQPVpgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 10:38 +0100, Robert Baldyga wrote:
> This patch moves code creating new i2c clients and regmaps to function
> drivers which use them. It allows to avoid creating this instances when
> individual function drivers are not enabled.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     |  131 +++++++++++++++++++++++++--
>  drivers/input/misc/max8997_haptic.c |  117 +++++++++++++++++++-----
>  drivers/mfd/max8997.c               |  169 +----------------------------------
>  drivers/rtc/rtc-max8997.c           |   78 +++++++++++-----
>  include/linux/mfd/max8997-private.h |   14 +--
>  5 files changed, 284 insertions(+), 225 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof



