Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab3LIBeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 20:34:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab3LIBeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 20:34:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH 5/9] ARM: dts: provide DMA config to pxamci
Date: Mon, 9 Dec 2013 02:33:58 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com> <1386543229-1542-1-git-send-email-ynvich@gmail.com> <1386543229-1542-6-git-send-email-ynvich@gmail.com>
In-Reply-To: <1386543229-1542-6-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312090233.58592.arnd@arndb.de>
X-Provags-ID: V02:K0:zBIOceJIjY7DNg1tdrhTh3/JHdAVFFXWUyf/LC0/5gy
 TozEbPPmuii7mJLQW5RZY4FlBc5uzGfixSeIl3zGcuD/VOtuDz
 RQa855KeSpi3wf5dzTzICiyjiRPPT0dOgfGG0SjKRlHoyKzzb6
 D3gJJsnOW9GOwpDmSj3RbQ+RA5gwnP5iRlvocFBhNtjiIP5r5P
 H+PgH1CKH7P9ZMXacufAt2Ot+Zzro2oevj0xCFqQAxTMGX3YIM
 yuevfIPC4Wlq0zghCwu7/V6N3/o23G2P2+N1X9dWJGFXD61V6R
 9SfIT0WIwTSfx5zbrREjg62oxbqJorhjZUQjU/FGWraIyha1OU
 wgwbdVVIQlEGnMfTOwN8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 December 2013, Sergei Ianovich wrote:
> Non-dts implementation supply required DMA channel numbers as
> IORESOURCE_DMA. However, there is was no way to get them from
> device tree.

I just wrote a lengthy reply to this email to explain in what ways
you got it wrong, but then I saw that Daniel has already done all
the work in the right way in August, so nevermind that.

It hasn't made it upstream yet, but see http://list-archives.org/2013/08/07/linux-mtd-lists-infradead-org/patch-00-20-arm-pxa-move-core-and-drivers-to-dmaengine/f/3444199144
for how it's done. Maybe Daniel can comment on the status of his
patches.

	Arnd
