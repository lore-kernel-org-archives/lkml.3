Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161057Ab3CVQ4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:56:08 -0400
Received: from void.printf.net ([89.145.121.20]:50726 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161000Ab3CVQ4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:56:06 -0400
From: Chris Ball <cjb@laptop.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: "'Dongjin Kim'" <tobetter@gmail.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Will Newton'" <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mmc: dw_mmc: Add MSHC compatible for Exynos4412
References: <1361210793-5710-1-git-send-email-tobetter@gmail.com>
	<1361546283-7479-1-git-send-email-tobetter@gmail.com>
	<002101ce1ff5$7f713fe0$7e53bfa0$%jun@samsung.com>
Date: Fri, 22 Mar 2013 12:56:00 -0400
In-Reply-To: <002101ce1ff5$7f713fe0$7e53bfa0$%jun@samsung.com> (Seungwon
	Jeon's message of "Wed, 13 Mar 2013 23:17:30 +0900")
Message-ID: <87ip4jml0f.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 13 2013, Seungwon Jeon wrote:
> On Saturday, February 23, 2013, Dongjin Kim wrote:
>> This patch adds the compatible string for MSHC controller of Exynos4412.
>> And exynos5250_dwmmc_caps is renamed to exynos_dwmmc_caps, since it has the
>> capablities of common feature supported by Exynos4 and Exynos5.
>> 
>> Cc: Seungwon Jeon <tgih.jun@samsung.com>
>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks, pushed to mmc-next for 3.10.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
