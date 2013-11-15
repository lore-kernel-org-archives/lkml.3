Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab3KONBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:01:03 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54369 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3KONAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:00:54 -0500
MIME-Version: 1.0
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C08BAEF@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C08BAEF@szxeml512-mbs.china.huawei.com>
Date: Fri, 15 Nov 2013 11:00:54 -0200
Message-ID: <CAGG-pUT22xoksid-2GmJsDmVQk8gR8zHvAr=r3Z2E4BLf+1jJA@mail.gmail.com>
Subject: Re: [PATCH] regmap: Fix 'ret' would return an uninitialized value
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Levente Kurusa <ilevex.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/15 Caizhiyong <caizhiyong@hisilicon.com>:
> From: Cai Zhiyong <caizhiyong@huawei.com>
> Date: Mon, 11 Nov 2013 19:26:14 +0800
> Subject: [PATCH] regmap: Fix 'ret' would return an uninitialized value
>
> This patch give a warning when calling regmap_register_patch with
> parameter num_regs <= 0.
>
> When the num_regs parameter is zero and krealloc doesn't fail,
> then the code would return an uninitialized value. However,
> calling this function with num_regs == 0, would be a waste as it
> essentially does nothing.
>
> Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
Reviewed-by: Geyslan G. Bem <geyslan@gmail.com>

Seems a good approach.
