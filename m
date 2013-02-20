Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291Ab3BTKMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:12:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29742 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883Ab3BTKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:12:29 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-cc-5124a18bf92f
Date: Wed, 20 Feb 2013 10:12:27 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 0/3] backlight: lp855x_bl: support new LP8557 device
To: milo.kim@ti.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jg1.han@samsung.com
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130220101056449@jg1.han
Msgkey: 20130220101056449@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130220101056449@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <4541358.778681361355146492.JavaMail.weblogic@epml28>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsVy+t8zI93uhSqBBu07NS0u75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJmdK7fwVrwjrNi8t+zzA2MJzi7GDk5hASUJCad3MsIYksImEicmtzK
	DmGLSVy4t56ti5ELqGYZo8SP9nfsMEUT7h9mgUjMZ5S4cacRLMEioCpxavkRNhCbTUBdYsLv
	ZhYQW1jAU+Lbwh1gtoiAhMSvB8vAapgFkiUu/fjMCnGFrMS9ybOZQWxeAUGJkzOfsEAsU5C4
	tLeRBSKuKPFk40ImiLiExJ37+1khbF6JGe1PoerlJKZ9XcMMYUtLnJ+1gRHmm8XfH0PF+SWO
	3d4BNIcDrPfJ/WCYMbs3f2GDsAUkpp45CNWqKrHnxAeotXwSaxa+hVolKHH6WjczTG/Dxt/s
	EG8pSkzpfghla0l8+bGPDd1bvAKOEl3vWpknMCrPQpKahaR9FpJ2ZDULGFlWMYqmFiQXFCel
	Fxkix/YmRkgi7N3BePuA9SHG/YzAOJnILCWanA9MpXkl8YbGxiZmJqYm5pam5qYUCJsbmRoA
	k6qBIXWElcR55S7JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpgrNxVv7c2u7hS89tj8bla
	L8Ok3H7KWutXf3rXp7X0UO3RAzxHz+RabzifwdAb9WT1uf+xmttWX1cNC5gQ89zE5Px5t+LD
	Xiwx5yuyrN5Ga03OU18yL0h6xVX/GUcdtW/b5GUbfxYrOJBv38u5MDW1+Utasvzj8M9Xt8c+
	XT494kfGuTOTAibtVGIpzkg01GIuKk4EAOz47bb3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2dN3uhSqBBsu3q1pc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jM71O1gL3nFWTP57lrmB8QRnFyMnh5CAksSkk3sZQWwJAROJCfcPs0DYYhIX7q1n62LkAqqZ
	zyhx404jO0iCRUBV4tTyI2wgNpuAusSE381gDcICnhLfFu4As0UEJCR+PVgGVsMskCxx6cdn
	VohlshL3Js9mBrF5BQQlTs58ArVMQeLS3kYWiLiixJONC5kg4hISd+7vZ4WweSVmtD+FqpeT
	mPZ1DTOELS1xftYGRpijF39/DBXnlzh2ewfQHA6w3if3g2HG7N78hQ3CFpCYeuYgVKuqxJ4T
	H6DW8kmsWfgWapWgxOlr3cwwvQ0bf7NDvKUoMaX7IZStJfHlxz42dG/xCjhKdL1rZZ7AKDcL
	SWoWkvZZSNqR1SxgZFnFKJpakFxQnJSeaqJXnJhbXJqXrpecn7uJEZyinvHtYJzXYHGIUYCD
	UYmHV2O+cqAQa2JZcWXuIUYJDmYlEd6fHSqBQrwpiZVVqUX58UWlOanFhxiTgRE4kVlKNDkf
	mD7zSuINjY1NzExMzQ0sDCzNSRNWEudVqpgeICSQnliSmp2aWpBaBLOFiYNTqoGxbcaDNaWC
	zlvzbjnN01S77OozY8P0GUqn/nMvqhc1n2/365ffM/WMKVK79LI7L8wrTU/ZX1Cfo6i6cYXf
	wxn9lx5/TzBrP6UanrAi9qfk7eKXHx++1XmY0HBt+SNLzZsnbuQrM4XKZT7Z73Bq88xdM36+
	XbT9qlTanlLfxycPZwtxZ5w09WDsV2Ipzkg01GIuKk4EAFFf5RiVAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1KACV30002952

On Tue, 19 Feb 2013 20:40:25 -0800, Kim, Milo wrote:
> 
> To support new device LP8557, LP855x device initialization process should be
> changed.
> This patch-set enables re-designing LP855x driver architecture and
> supporting LP8557 device.
> Milo(Woogyom) Kim (3):
>   backlight: lp855x_bl: introduce device configuration flow
>   backlight: lp855x_bl: support new LP8557 device
>   backlight: lp855x_bl: simplify bl_get_brightness()

These patches look good.
Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

>
>  Documentation/backlight/lp855x-driver.txt |    4 +-
>  drivers/video/backlight/Kconfig           |    2 +-
>  drivers/video/backlight/lp855x_bl.c       |  169 ++++++++++++++++++++++-------
>  include/linux/platform_data/lp855x.h      |   19 ++++
>  4 files changed, 152 insertions(+), 42 deletions(-)
>
> -- 
> 1.7.9.5
>
>
> Best Regards,
> Milo
>
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
