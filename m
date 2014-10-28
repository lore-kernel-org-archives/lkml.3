Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaJ1OZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:25:16 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:63846 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJ1OZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:25:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Xia Kaixu <kaixu.xia@linaro.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/5] ARM: allow errata and XIP options to be enabled without ARCH_MULTIPLATFORM_STRICT
Date: Tue, 28 Oct 2014 15:24:38 +0100
Message-ID: <6893071.4YhqEbdaBz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141028140231.GE27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org> <1414503095-25986-5-git-send-email-kaixu.xia@linaro.org> <20141028140231.GE27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2LzTRX/qeHqsMkKE4IkXpkKMXJGZRNruB/jBsFzzGKv
 7QxhkM2M33T4Xrr096Ntske38pNYTY3CvZGbstaIEpYmRSzkdA
 TAXua0RrGIju7LC4WcoRJe8j5Aq1kIcMMbviUqUid37ERc3KuF
 HnWuF9ZrTaaBnfDFTaT2biP0VV18iEpHljKM1BLyNYogI6qFq1
 62rREq0bqB65HvJxynVBkR4URjWCKvXnZ+oKDgwQVug8RH10c8
 ZsPeEk/zPHVgHhXFOq3yT95qOfzzqbY7fRXQpIjnp0IJnjIS0B
 MkuJK9iCsKDQori49osRdluk4yRHPDiep5Mud1q4rt5e1GP0qM
 emqwg7+elSFYBjr1KOcI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 14:02:31 Russell King - ARM Linux wrote:
> On Tue, Oct 28, 2014 at 09:31:34PM +0800, Xia Kaixu wrote:
> > With the ARCH_MULTIPLATFORM_STRICT option, it becomes much easier to
> > enable the ERRATA options when we know at configuration time that we
> > don't care about the generic case. The previous configuration makes
> > XIP_KERNEL option fundamentally non-MULTIPLATFORM, but it's still
> > valid to select it when building for !ARCH_MULTIPLATFORM_STRICT and
> > selecting only the one machine that you want to run on.
> 
> XIP_KERNEL isn't supported on anything past ARMv5 though.

I would really like to get some of the platforms that currently use
XIP_KERNEL to use ARCH_MULTIPLATFORM in the long run. One of them
is EFM32, which is ARMv7-M.

> I don't like the case for errata though - we want these errata to be
> handled by the board firmware, not by the kernel, and we don't want
> to make it any easier for people to ignore that fact.

Ok, fair enough.

	Arnd
