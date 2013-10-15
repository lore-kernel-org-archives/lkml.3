Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab3JOTZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:25:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65384 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab3JOTZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:25:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] hpet: remove deprecated IRQF_DISABLED
Date: Tue, 15 Oct 2013 21:25:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: clemens@ladisch.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <1381636427-5877-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1381636427-5877-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201310152125.00611.arnd@arndb.de>
X-Provags-ID: V02:K0:XUyOJk3OHsdHsHW1yTZh+pxTCAUT/+5zslHch17BWkK
 u9vRDfdw5YICiAWlJhuzZ6C6JnUN61mSfq1YMbx5Szw52yrGAv
 KNVEil+E5aEX39z5H/mNRe/lPrYK0ZtvP6nuvaXfDDXrE2xLmU
 8YwV3PdE10iemjrtJfbq92oVmP/Rg5vZO9rIKj8PJYM7ccgpmJ
 BvyM4OnUBK74AeHwkG1KQ4Ksic2RfTbEJ8wSzb0KtOJqrPXbmB
 HIfYpNbW2ZEei9KofrGrKNbs/53yYKciRMJQGJ5u4JibMkrPFc
 3GT6Gn11/Z1LQKqeJhZI8bPlP2v2s6FT2Ry9fsMBROpbVV7z4z
 VoxcXf3V7fReUc50XXc8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 October 2013, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

for all drivers/misc and drivers/char patches:

Acked-by: Arnd Bergmann <arnd@arndb.de>

Since the patches should all be trivial, you might consider doing
one patch per subsystem rather than one patch per driver, but that
depends a bit on the preference of the subsystem maintainer.

	Arnd
