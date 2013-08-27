Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3H0Nkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:40:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29263 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3H0Nkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:40:45 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-d8-521cac5bf106
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: linus.walleij@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, thomas.abraham@linaro.org, kgene.kim@samsung.com,
        l.krishna@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [Patch v2] pinctrl: Add s5pv210 support to pinctrl-exynos
Date: Tue, 27 Aug 2013 15:40:40 +0200
Message-id: <3696905.8yvPmhxxxP@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1377608890-8528-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377608890-8528-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Fd3oNTJBBm+eCVvMP3KO1eJNbweL
	Re+Cq2wWO7fcYLOY8mc5k8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCxOrznFbLH0+kUmiwnT17JY
	HF5xgMli3cvpLBavDraxWBybsYTRQcBjzbw1jB4LPl9h93g9eQKjx6vVM1k97lzbw+axeUm9
	x8F3e5g8+rasYvT4vEnOY+Pc0ACuKC6blNSczLLUIn27BK6M6cvXsxXMZqtYPmkyYwPjfpYu
	Rk4OCQETiebN85ggbDGJC/fWs3UxcnEICSxllLi7oYcJwuliknjxcQszSBWbgJrE54ZHbCC2
	iICpxLu718A6mAUmMku8ebaHHSQhLOAmsbLxF1gDi4CqRPOJeWBxXgFNiU8n1jOC2PwC6hLv
	tj0F2sDBISrgItH3NxMkzCngJ/F71g+w64QEfCVmTjzBBtEqKPFj8j2wOLOAvMS+/VNZIWwt
	ifU7jzNNYBSchaRsFpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIicMvOxgX
	H7M6xCjAwajEw/ugRTpIiDWxrLgy9xCjBAezkgjv7hUyQUK8KYmVValF+fFFpTmpxYcYmTg4
	pRoYBboco24bK3qHXXkXzWBh79v/sk8iyDOidynjj7bNwvLvuyMOVU+RjX/xttfU5G6w9Wev
	dT9YCh4eZrx18jLzjcNc69vq31rq6alcUF5whU32u0RTqtXcTtc9EzsNZ5m9tL3L+UW7x/LQ
	D9+34dsMd/e1iUxcdWN/ukHW89Uurj/ueBtcu6qgxFKckWioxVxUnAgA3/9e56ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Tuesday 27 of August 2013 15:08:10 Mateusz Krawczuk wrote:
> This patch implements pinctrl support and adds device tree bindings
> for s5pv210.
>
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  .../bindings/pinctrl/samsung-pinctrl.txt           |  3 +-
>  drivers/pinctrl/Kconfig                            |  2 +-
>  drivers/pinctrl/pinctrl-exynos.c                   | 58
> ++++++++++++++++++++++ drivers/pinctrl/pinctrl-samsung.c                
>  |  2 +
>  drivers/pinctrl/pinctrl-samsung.h                  |  1 +
>  5 files changed, 64 insertions(+), 2 deletions(-)

Acked-by: Tomasz Figa <t.figa@samsung.com>

As a side note, please write the PATCH keyword in the topic in upper case 
next time.

Best regards,
Tomasz

