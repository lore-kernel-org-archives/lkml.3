Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab3FAIlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 04:41:49 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:36636 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3FAIli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 04:41:38 -0400
Message-ID: <51A9B3BC.9000405@gmail.com>
Date: Sat, 01 Jun 2013 10:41:32 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de,
        kgene.kim@samsung.com, olof@lixom.net, patches@linaro.org,
        t.figa@gmail.com
Subject: Re: [PATCH 3/3] ARM: S5P64X0: Remove duplicate uncompress code
References: <1370000944-19786-1-git-send-email-tushar.behera@linaro.org> <1370000944-19786-4-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370000944-19786-4-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/31/2013 01:49 PM, Tushar Behera wrote:
> The uncompress code in S5P64X0 is almost same as the uncompress code
> defined in plat-samsung. Better to reuse that code.
>
> Signed-off-by: Tushar Behera<tushar.behera@linaro.org>
> ---
>   arch/arm/mach-s5p64x0/include/mach/uncompress.h |  163 ++---------------------
>   1 file changed, 8 insertions(+), 155 deletions(-)

Not sure if you are aware of it, Tomasz has already posted a patch that
removes this duplicated code: https://patchwork.kernel.org/patch/2589331
I think that patch is not yet merged though.

Regards,
Sylwester
