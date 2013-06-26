Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3FZXhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:37:06 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52550 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3FZXhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:37:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2 5/9] ACPI: introduce three helper functions
Date: Thu, 27 Jun 2013 01:46:33 +0200
Message-ID: <57192011.2AdLNpNKNS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1769605.QbZVOi8JUg@vostro.rjw.lan>
References: <1372264261-17442-1-git-send-email-liuj97@gmail.com> <1372264261-17442-6-git-send-email-liuj97@gmail.com> <1769605.QbZVOi8JUg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 26, 2013 08:49:21 PM Rafael J. Wysocki wrote:
> On Thursday, June 27, 2013 12:30:57 AM Jiang Liu wrote:
> > From: Jiang Liu <jiang.liu@huawei.com>
> > 
> > Introduce three helper functions, which will be used to simplify code.
> 
> First, please introduce acpi_has_method() and use it everywhere where
> applicable (at least under drivers/acpi/)

Well, except for drivers/acpi/acpica/.  And even that might be too much ...

Please just move the definition of acpi_has_method() and all of the
simplifications you've done using it into one separate patch.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
