Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3EPMWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:22:42 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:42414 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3EPMWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:22:40 -0400
MIME-Version: 1.0
In-Reply-To: <1368702961-4325-9-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de> <1368702961-4325-9-git-send-email-wsa@the-dreams.de>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 16 May 2013 20:22:19 +0800
Message-ID: <CAGsJ_4zAJpqxjg_rcO1WxS=GLii7YooPnsCgt40frf_5afiY6g@mail.gmail.com>
Subject: Re: [PATCH 08/33] drivers/i2c/busses: don't check resource with devm_ioremap_resource
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/16 Wolfram Sang <wsa@the-dreams.de>:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Barry Song <Baohua.Song@csr.com>

-barry
