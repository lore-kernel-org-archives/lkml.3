Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711Ab3FSK7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:59:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934460Ab3FSK7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:59:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robin Holt <holt@sgi.com>
Cc: akpm@linux-foundation.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v11 resend 10/11] arm, change reboot_mode to use enum reboot_mode
Date: Wed, 19 Jun 2013 12:58:10 +0200
Message-ID: <4169120.1k31YLDD12@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.4; x86_64; ; )
In-Reply-To: <1370519244-49918-11-git-send-email-holt@sgi.com>
References: <1370519244-49918-1-git-send-email-holt@sgi.com> <1370519244-49918-11-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4cteXPBafsVkhjbwpkIwUPPi5sZnlHsS816uHPuAGVZ
 g3CGUOKWIDrjPkqTh9mZ9yQvFVa2h82lpaiWwb+RgPYz8KO27D
 nd6rFZrM3dSvQSkDMFG6n1xRXPbu2F2qUp58K06wDM6kpx66j9
 ApkNnFNEUqmOn5nZ/ROp1qTSIqfZA6bIAgDDFHq7M8BTkLOlXd
 BjkW7iYqHVwqDiiSSrzPoWTNB5votuKU/4VO1k0QyqY8N1Rp9s
 invSvj2u6jfJQFQ2gN1a0uG0xpvHbVhMJUSXdBBcNJlQKBvUHE
 HA2t4kONJin3cR51uAax+Yx9bizOETW1TAi49/ojJ/aDtmj19I
 9lOPaKjK5F1ASQJeGYeQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 June 2013 06:47:23 Robin Holt wrote:
> Preparing to move the parsing of reboot= to generic kernel code
> forces the change in reboot_mode handling to use the enum.
> 
> Signed-off-by: Robin Holt <holt@sgi.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Russ Anderson <rja@sgi.com>
> Cc: Robin Holt <holt@sgi.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: the arch/x86 maintainers <x86@kernel.org>
> Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Should we merge this through the arm-soc tree?

I'm getting a few conflicts with new platforms getting added
using the old interface.

	Arnd
