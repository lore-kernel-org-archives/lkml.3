Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3AVI2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:28:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3AVI2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:28:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Date: Tue, 22 Jan 2013 08:27:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: John Stultz <john.stultz@linaro.org>, Matt Sealey <matt@genesi-usa.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <50FDBEAC.2050606@linaro.org> <20130121224449.GZ23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130121224449.GZ23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301220827.55209.arnd@arndb.de>
X-Provags-ID: V02:K0:9UURG9rgzMcWgNHfyKYkuzhSvEp/r+ED9Qp8wBUPc/y
 LtE64zuwWAizdCaNANa9H5GB7DfvEJObG8qb6cxJlMEbsmeAkq
 aVQM7gtgvQCc/xQJMPoZa5hFuSXoy71BfECHjDyvaSjmFaV1Za
 BByrpa0V7GIUe3ol9Ud5uQ827cTx2efIeY3Qx6kEesRwWUtDVV
 /NrEJUDR+d+hDJ+jLSM3tXGYflimrfrdeWy0oTKot3s2Fuv50z
 1IZB5SabWlZaMg0r9PC+O5SNvKzow1TZKVfGX7Y+WVVm+t8Y0d
 G9qSK5GNKaWPJt/6etwsCfE/ZG8TO6VB3Hz4L8PHDbnPKONR/s
 rAVDyaQoSraGEuBEom+c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Russell King - ARM Linux wrote:
> In this particular case, EBSA110 is not a candidate for multi-arch
> build anyway, because it's ARMv4 and we're only really bothering with
> ARMv6 and better.
> 
> Not only that, but the IO stuff on it is sufficiently obscure and
> non-standard...

Right, no point worrying about EBSA110. We need to work out OMAP and
Exynos/S5P though: As long as OMAP needs 128HZ and Exynos needs 200HZ,
we can never have them in the same kernel.

	Arnd
