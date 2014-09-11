Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaIKW7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:59:52 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45089 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaIKW7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:59:50 -0400
Message-ID: <54122962.5020903@gmail.com>
Date: Fri, 12 Sep 2014 00:59:46 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: kgene.kim@samsung.com, s.nawrocki@samsung.com, mturquette@linaro.org,
        Chander Kashyap <k.chander@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH] clk: samsung: exynos5260: fix typo in clock name
References: <1410328565-25122-1-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1410328565-25122-1-git-send-email-pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 10.09.2014 07:56, Pankaj Dubey wrote:
> From: Chander Kashyap <k.chander@samsung.com>
> 
> The parent name added in parent list as
> mout_phyclk_mipi_dphy_4l_m_txbyte_clkhs_p, is different
> than the defined parent due to typo.
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>

Missed your sign-off? You can reply with it inline and I will add it
when applying this weekend.

P.S. Please keep me on CC when sending patches for Samsung clock drivers.

Best regards,
Tomasz
