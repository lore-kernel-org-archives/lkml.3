Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaLSHwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 02:52:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62479 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaLSHwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 02:52:09 -0500
X-AuditID: cbfee68e-f79b46d000002b74-f6-5493d92473f2
Date: Fri, 19 Dec 2014 07:52:04 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH RESEND v2 03/10] power: charger-manager: Remove deprecated
 function, cm_notify_event().
To: =?utf-8?Q?=EC=9D=B4=EC=A2=85=ED=99=94?= <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "anton@enomsg.org" <anton@enomsg.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141219075128971@myungjoo.ham
Msgkey: 20141219075128971@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141219075128971@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1255984171.39711418975524329.JavaMail.weblogic@epmlwas08d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkWFfl5uQQg0WvFSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG/yOegklcFe/bOtkbGN9wdjFycggJqEssWnKSDcSWEDCRODa/
	ixXCFpO4cG89G0TNUkaJi5+rYGpO/n4AFOcCis9hlDj3ewZYA4uAqsS1xh1ACQ4ONgE9iZmf
	k0FMYYFsiZYr/CDlIgKdjBIX1jSxgjjMAmeZJG63/GGBWKAksWbfKzCbV0BQ4uTMJywQy1Ql
	Tr3+xQwyiFdATeLATg2IsLjEhbmX2CFsXokZ7U+hyuUkpn1dwwxhS0ucn7WBEeaXxd8fQ8X5
	JY7d3sEEYQtITD1zEKpGS6J9zVaomXwSaxa+ZYGp33VqOTPMrvtb5kL1SkhsbXkC9jqzgKLE
	lO6H7CBnMgtoSqzfpY/uE14Bd4njn56xgLwuITCRQ2Jm9w3GCYxKs5DUzUIyahbCKGQlCxhZ
	VjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIEpoTT/5717WC8ecD6EKMAB6MSD29H4eQQIdbE
	suLK3EOMpsBImsgsJZqcD0w8eSXxhsZmRhamJqbGRuaWZkrivAlSP4OFBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MObXv7z130iFI3naLQX14xtu8jw1M5A3m/f+Qqbse2l1j7CgRd+fa5zo
	srjrnad0xMX229qPWwXP1H334i/l3vqQ79dPgdrIlYn7jtQtPVZ0We9Z5YrokxxzVsXtOKC7
	4s3U4zE2wrvvr2qRi0ubEXAzLETM7W3i2RoJw0zfgl8/rTmmhtlWr1BiKc5INNRiLipOBABt
	4BNvBAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t/tfl2Vm5NDDL48lbS4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRn9
	j3gKJnFVvG/rZG9gfMPZxcjJISSgLrFoyUk2EFtCwETi5O8HULaYxIV764FsLqCaOYwS537P
	YAVJsAioSlxr3AGU4OBgE9CTmPk5GcQUFsiWaLnCD1IuItDJKHFhTRMriMMscJZJ4nbLHxaI
	ZUoSa/a9ArN5BQQlTs58wgKxTFXi1OtfzCCDeAXUJA7s1IAIi0tcmHuJHcLmlZjR/hSqXE5i
	2tc1zBC2tMT5WRsYYW5e/P0xVJxf4tjtHUwQtoDE1DMHoWq0JNrXbIWaySexZuFbFpj6XaeW
	M8Psur9lLlSvhMTWlidgrzMLKEpM6X7IDnIms4CmxPpd+ug+4RVwlzj+6RnLBEbZWUhSs5B0
	z0LoRlaygJFlFaNoakFyQXFSeoWRXnFibnFpXrpecn7uJkZwAnq2aAfjv/PWhxgFOBiVeHg7
	CieHCLEmlhVX5h5ilOBgVhLhdTwOFOJNSaysSi3Kjy8qzUktPsRoCoyyicxSosn5wOSYVxJv
	aGxsYmZiamliYWBqriTO+/9cboiQQHpiSWp2ampBahFMHxMHp1QDY9NDk4Sgb17OLusuxl9w
	+bUgTH6j5+HNfm/eH3r0/KRz79rKTzfb58VvPV68a3/AioA7y7cuOxt4lOtEwO0dCreC5te3
	BohE+jKYV1QuVc1eGbH5ltScVU++q7keD5QUremcdbRiSmTUjVWv86VXl+m1OXVWZ8/5cCT3
	m/0akQYht6QzhSxGPUosxRmJhlrMRcWJAGa9njhWAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBJ7qV6u020698

>   
>  cm_notify_event() is introduced to get event associated with battery status
> externally, but no one had been used. Moreover it makes charger manager
> driver more complicated. This patch tries to drop the function and all data
> related to simplify the driver.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>

You are not just removing cm_notify_event() and its related.

You are hereby removing the much of software charger control
and suspend-related operations. Could you please be more specific
on why? (many of such features are to comply with operators' requirements)

(Or we may meet next Monday for some discussions :) )

> ---
>  .../bindings/power_supply/charger-manager.txt      |    1 -
>  drivers/power/charger-manager.c                    |  196 +-------------------
>  include/linux/power/charger-manager.h              |   19 +-
>  3 files changed, 8 insertions(+), 208 deletions(-)
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
