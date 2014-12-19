Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaLSIeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:34:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59144 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaLSIef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:34:35 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-f79b46d000002b74-73-5493e318f433
Content-transfer-encoding: 8BIT
Message-id: <5493E318.1000608@samsung.com>
Date: Fri, 19 Dec 2014 17:34:32 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        pavel@ucw.cz, myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: Re: [PATCH RESEND V2 0/10] Improve charger manager driver for
 optimized operation.
References: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
In-reply-to: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkSFfy8eQQgzv3mSwObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZcyev4y9YBZ/xawngg2M
	F7m7GDk5JARMJF5+/cAOYYtJXLi3nq2LkYtDSGApo0TPtdXsMEXzlx5hgkgsYpSYf+44E0iC
	V0BQ4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+aUeL4hcNQ9VoSX0/3sIHYLAKqEida
	NoDF2QTkJN42fWMEsUUFwiSuTjjOAmKLANVfe/yOEWLoKUaJS6vBrhYWiJW4vPA52HFCAu4S
	J769BavnFPCQeHqpCewDCYGP7BJ3bhxlhFgmIPFt8iGwQyUEZCU2HWCGeExS4uCKGywTGMVm
	IXlnFsI7s5C8s4CReRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGYHye/vesbwfjzQPWhxgF
	OBiVeHg7CieHCLEmlhVX5h5iNAU6YiKzlGhyPjAJ5JXEGxqbGVmYmpgaG5lbmimJ8yZI/QwW
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLi6+HydX1rE6oqPU9fe3pmcs4dh0ZeDycJqT19U
	tJ45v1Bni9+Mus7XcXN7lxaEMFg5Wv/3WVu7xDBiYdHuJuNJKfqR907FLkk4pnL0fqXU85zK
	J+ffze3LfjuV56xha81zycn3PSady3b+F/x6TQfrj5WXO/mea06/su2PUNIHuwXrS6svi55V
	YinOSDTUYi4qTgQAkZ2ux8oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xgK7E48khBi9mmlkc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2aLz7BNmi8u75rBZfO49wmhxu3EFm8XdU0fZLE7vLnHg8pjQ/4nRY+esu+we
	m1doeWxa1cnm0bdlFaPHitXf2T0+b5ILYI9qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5gxe/4y9oJZ/BWzngg2MF7k7mLk5JAQMJGYv/QIE4QtJnHh3nq2LkYuDiGBRYwS
	888dB0vwCghK/Jh8j6WLkYODWUBe4silbJAws4C6xKR5i5gh6l8zShy/cBiqXkvi6+keNhCb
	RUBV4kTLBrA4m4CcxNumb4wgtqhAmMTVCcdZQGwRoPprj98xQgw9xShxaTXYccICsRKXFz5n
	B7GFBNwlTnx7C1bPKeAh8fRSE9sERoFZSM6bhXDeLCTnLWBkXsUomlqQXFCclJ5rqFecmFtc
	mpeul5yfu4kRHP3PpHYwrmywOMQowMGoxMPbUTg5RIg1say4MvcQowQHs5IIr+NxoBBvSmJl
	VWpRfnxRaU5q8SFGU6DnJjJLiSbnAxNTXkm8obGJmZGlkbmhhZGxuZI4r5J9W4iQQHpiSWp2
	ampBahFMHxMHp1QD4+l3rnu+pdc8T3zx7facVwvyjJcaO3e8nnH0uPXG1Vf/2M9+s/zGESfv
	2qhTjDk8cxOcSzvr2OrvSer+VjreJeR7bXZCybm82yF6FkaTRCfsuvZq5++rRs6HaspO9Nlv
	lW3iPV/epn/b/3Diz1W6k7YIz/h2bdHpskvxK/1n/+zJFNsZtfaOyFklluKMREMt5qLiRABF
	QcudFAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 12월 19일 11:47, Jonghwa Lee wrote:

> After charger manager's initially introduced, it has kept its codes without any
> big change. However, the charger manager working operation isn't optimized and
> it also has unused codes and non-generic interface. This series tries to make
> charger manager more generic and maintainable with some fixes.
> 
> [Changes in V2]
> - Rebase patch series on latest of battery-2.6.git.
> - Seperate 'power: charger-manager: Rearrange data and monitor ~' patch into
>   several patches depends on its purpose.
> - Add 2 patches related with polling mode.
> 
> Jonghwa Lee (10):
>   power: charger-manager: Use thermal subsystem interface only to get
>     temperature.
>   power: charger-manager: Use power_supply_changed() not private
>     uevent.
>   power: charger-manager: Remove deprecated function,
>     cm_notify_event().
>   power: charger-manager: Fix to use CHARGE_NOW/FULL property
>     correctly.
>   power: charger-manager: Concentrate scattered power_supply_changed()
>     calls.
>   power: charger-manager: Get external power souce information only
>     from EXTCON.
>   power: charger-manager: Make chraging decision focusing on battery
>     status.
>   power: charger-manager: Not to start charging directly in cable
>     nofitication.
>   power: charger-manager: Support different polling mode for sleep
>     state.
>   power: charger-manager: Support to change polling rate in runtime.
> 
>  .../bindings/power_supply/charger-manager.txt      |    1 -
>  drivers/power/Kconfig                              |    1 +
>  drivers/power/charger-manager.c                    |  758 ++++++--------------
>  include/linux/power/charger-manager.h              |   34 +-
>  4 files changed, 219 insertions(+), 575 deletions(-)



Oops, I omitted a patch from series,
I'll resend it again.

Sorry for noise.

Thanks,
Jonghwa

> 


