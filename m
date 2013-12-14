Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3LNTHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:07:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3LNTHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:07:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 03/16] ARM: dts: provide DMA config to pxamci
Date: Sat, 14 Dec 2013 20:06:26 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        linux-mmc@vger.kernel.org
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> <1386901645-28895-1-git-send-email-ynvich@gmail.com> <1386901645-28895-4-git-send-email-ynvich@gmail.com>
In-Reply-To: <1386901645-28895-4-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312142006.26979.arnd@arndb.de>
X-Provags-ID: V02:K0:Bi52mSgnLRZmVrT9jQAPxKhL9oUhHcZYps3Y232gvRG
 uYX/iIrpDIfDw/+RvsrGXJxQIWOWIy9g6dSkG8edWjIA+NqV6s
 WdgVgwNHGytd30lJyuU3KyWgBpXYdrJSVDpOkbtZorlEYKs6Hv
 GqaUBJvtYj71UfDDzreTBAq4xJt7e67n3WWjjM8sCH2FS85+eP
 mKqv2UWyxLw0PNw91RS46sdWjBkscGs+6cHGKPAlvtAfdB9tTD
 OEmkS3NXqVfISGcP7Uefolw8FUglZv2YfzLn9eE8oyxolXRO43
 7UuXygUecESmaWzz6AAPNUIE1d5MJBi12Y91RxfeBOImQndu6u
 YwNG4p3g4BLbtok4k8w8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 December 2013, Sergei Ianovich wrote:
> Non-dts implementation supply required DMA channel numbers as
> IORESOURCE_DMA. However, there is was no way to get them from
> device tree.

Please update this changeset comment, I think it still refers to
the earlier version.
 
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> CC: Daniel Mack <zonque@gmail.com>
> CC: Arnd Bergmann <arnd@arndb.de>

The patch looks ok in case we are merging your patches for 3.14
and Daniel's patches later than that. If they end up in the
same merge window however, we'd have to be care to resolve
the obvious conflict in a proper way.

	Arnd
