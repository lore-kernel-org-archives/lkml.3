Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3AVPnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:43:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3AVPnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:43:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 06/15] clk: export __clk_get_name
Date: Tue, 22 Jan 2013 15:43:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>, arm@kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <1358788568-11137-7-git-send-email-arnd@arndb.de> <CAOMZO5AON+FhTQpTbEdjwZaEaxsPoEVLeALhH2s34biWH_EeOA@mail.gmail.com>
In-Reply-To: <CAOMZO5AON+FhTQpTbEdjwZaEaxsPoEVLeALhH2s34biWH_EeOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221543.18859.arnd@arndb.de>
X-Provags-ID: V02:K0:GT57dFh10rY9ncDPVFTMvK1Z2oaUaqnXGN9jJ6sfbCM
 SNnwzCzS9kuXjmK0pOliUNlDuj0TgH+UBlKbPAqUxCpfES0+wG
 EzkMHf8mKLSJVT1r9ouY3pocBizK6cZQBMcDASQCGB/gQThKH4
 /hS1ViQDy+BJD1JJJxZNNFJzfExMfO1Ug0bDaUJN/YV4ZeyeRc
 gvIpvCMJ1Jk1hsp/GsUSgYWXR+Ak875gYvkC+nR7yZl9Jaw8pr
 jfaSbv3LaPVdSPgyRkDDgi0np01CMmtZA4fzitge45w7Qzw2C/
 ZfMj5Kug9cKVbtI+O+egNKHYtJXWo6y6vY9UuLejC1DlqFejKJ
 p9Pq2h0mtZ8Nr4JxU/GU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Fabio Estevam wrote:
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Mike Turquette <mturquette@linaro.org>
> 
> A fix from Niels de Vos has already been applied into clk-next:
> https://patchwork.kernel.org/patch/1871981/

Ok, very good. Mike, I saw that the patch is over
a month old. Any reason it hasn't made it into v3.8.rc yet?

	Arnd
