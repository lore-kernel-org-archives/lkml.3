Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3AROsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:48:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59405 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3AROsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:48:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 44/76] ARC: ptrace support
Date: Fri, 18 Jan 2013 14:48:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-45-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-45-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181448.15162.arnd@arndb.de>
X-Provags-ID: V02:K0:R9IP3EA3DWB0fCaLPkA4EBACWKzj0oPJLbAH+SXBo2c
 +Mo6bWgrKQlDmOkwqMCiw/BtvB1EeAF9ZCDVcJEFx6gk7ZGHXv
 SRALde5HeFaWTTZeR1UxBDcgmoYH4LrmXqP1vtRMPiOS1vI9rF
 i7crXo9wkanF474In3tlUsaJgLLtQ6JD5G2+kJ/7cOI+KriClh
 8PPIBHw2IQehfZdqmLSga2V+XOsodwXQR0UXcCn7f0q7fMFaxR
 0FHkd/frD2y9Ep3IgtPK4v1ixH4Ji5BCpkN0xoEkGpd7rPHaW8
 /v8y54c45xUVAh/hz1fYMqXiv2uEi4Ec/gfmVL7vzsZxNmznIS
 IBp4Em51pVk1Fs6uVEkA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/arc/Kconfig         |    1 +
>  arch/arc/kernel/Makefile |    3 +
>  arch/arc/kernel/entry.S  |   69 +++++++++++++++++++++++
>  arch/arc/kernel/ptrace.c |  136 +++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 207 insertions(+), 2 deletions(-)

Acked-by: Arnd Bergmann <arnd@arndb.de>
