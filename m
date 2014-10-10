Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaJJVK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:10:28 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54340 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaJJVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:10:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org,
        thomas.petazzoni@free-electrons.com, computersforpeace@gmail.com
Subject: Re: [PATCH v3 0/2] bus: brcmstb_gisb: misc fixes
Date: Fri, 10 Oct 2014 23:10:22 +0200
Message-ID: <1956888.MIJ5XMTDdo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5438329D.1040600@gmail.com>
References: <1411408966-15390-1-git-send-email-f.fainelli@gmail.com> <5438329D.1040600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RVjVQ8raV0ZpHc3YKNXrr0uyNTae9uUjlkbG9EFYX8i
 VnLMWO5QvMJW/EchCnXrG+303TMAoKtxfW5RHMYfTEHoV6g6BM
 Ft1ESTjv/Qv4MBeWTb4K1cH1HmhFpLl/3BhT6NM4sBVWOPedOr
 t8ED61/kfwD0FPDkI/CTESqf3c0rf0HHWHlPDWLY5oMHEfUkIo
 SuLZYfSHRONfeVoAdGHqVktyQk4S9OSkwvTnpp1giw8yWzJUm1
 6ykHZzW3O6BTbBuZSVnhH2ehDL/KIGAmYMMYjE/Xk+2vJsIm1P
 Zz3OIYhAN9CZQLuXerXscH7lb+mAvk3f2SlUvkNZnIqlZHyj3N
 eZIdCpfh2b4BFoUxyN5k=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2014 12:25:17 Florian Fainelli wrote:
> 
> On 09/22/2014 11:02 AM, Florian Fainelli wrote:
> > Hi Arnd,
> > 
> > This patch set contains two small fixes for the Broadcom GISB bus
> > arbiter code. First patch makes sure we do register a fault code for
> > ARM platforms, second patch is a fix when the code is used on a PM
> > capable system.
> 
> Once the merge window re-opens in about a week from now, how do you want
> me to submit those patches? Do you want them as part of a brcmstb pull
> request, or something else?

At least one of us is confused. The merge window is currently open,
and I have send all outstanding pull requests for 3.18. If you have
bug fixes that are required for 3.18, we should merge them now and
send them as soon as possible.

If this is stuff that can wait for 3.19, please send a pull
request after the the end of the ELC/LPC conferences next week
so we can queue it up in next/fixes-non-critical.

	Arnd
