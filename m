Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaK1PIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:08:49 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:57499 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaK1PIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:08:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 RESEND 1/2] ARM: vexpress: Remove non-DT code
Date: Fri, 28 Nov 2014 16:08:34 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Pawel Moll <pawel.moll@arm.com>, arm@kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>, linux-kernel@vger.kernel.org,
        Sudeep Holla <sudeep.holla@arm.com>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201411281608.34978.arnd@arndb.de>
X-Provags-ID: V02:K0:iZ2ifApYmTjJHqfR20qSR9f2aS0KufFd5d9J4nSGFQf
 C9obr6OsjE3zknT9bvOO7pR8n7ckwQ67OTd6QxRJ9fGDCg4y0w
 c/MS/uF4vcrcZOTz5CksN+WIW6n32hOtPfjczRZ74RtFZQEz0o
 FdXUk1/SYChyWMlISrxgJESJxXj8dClllvTpkzyU+A+Tv/Xorc
 zmBndR+q1mU4puIu61acoU2E7MNIDcTj5HDZLjRe1jYEGlyuQV
 dIdHjQ/qfeJT7IsoN6SLUxK+zmYqA5YIvw7gnSybgndXxXznAg
 hwJ3sBIZjCpiUpt2HJ/kwZnlCjg3VeaT+TFspvDyZD73f+95da
 /21F82V/yNEbxYtPechj3dh3cphCkzvjgXCo91jxi
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2014, Pawel Moll wrote:
> Now, with the CLCD DT support available, there is no
> more reason to keep the non-DT support for V2P-CA9.
> 
> Removed, together with "some" supporting code. It was
> necessary to make PLAT_VERSATILE_SCHED_CLOCK optional
> and selected by the machines still interested in it.
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
> Changes since v1:
> 
> - Removed MFD and power/reset changes from the patch;
>   will be posted separately after this is merged.

Applied to next/cleanup, thanks!

	Arnd
