Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbaJXLsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:48:45 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59356 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaJXLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:48:43 -0400
Message-ID: <544A3C96.9080007@gmail.com>
Date: Fri, 24 Oct 2014 13:48:38 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com
CC: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 2/3] ARM: dts: Add sleep mode pin configuration for
 exynos3250-rinato
References: <1414150795-31105-1-git-send-email-cw00.choi@samsung.com> <1414150795-31105-3-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1414150795-31105-3-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 24.10.2014 13:39, Chanwoo Choi wrote:
> This patch add sleep mode pin configuration using pinctrl subsystem
> to reduce leakage power-consumption of gpio pin in sleep state.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <Kyungmin Park@samsung.com>

I suspect a typo in this email address. Kukjin, is this something you
could fix up when applying (other patches in this series have it correct)?

Best regards,
Tomasz
