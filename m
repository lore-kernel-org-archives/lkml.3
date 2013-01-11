Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3AKRMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:12:03 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56824 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab3AKRMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:12:01 -0500
Message-ID: <50F04787.6030206@imgtec.com>
Date: Fri, 11 Jan 2013 17:10:31 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Mike Frysinger" <vapier@gentoo.org>,
        David Howells <dhowells@redhat.com>,
        "Hirokazu Takata" <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Koichi Yasutake" <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH] consolidate per-arch stack overflow debugging options
References: <20130111170043.D7CC39DC@kernel.stglabs.ibm.com>
In-Reply-To: <20130111170043.D7CC39DC@kernel.stglabs.ibm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_11_17_11_52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/13 17:00, Dave Hansen wrote:
> 
> I'm looking for some Acked-bys on this from the various arch
> maintainers that it affects.  I'd like to send it up to Linus
> in the next merge window.  This is part of a larger series to
> clean up the "Kernel Hacking" menu:
> 
> 	https://lkml.org/lkml/2012/12/17/306
> 
> --
> 
> Several architectures have similar stack debugging config options.
> They all pretty much do the same thing, some with slightly
> differing help text.
> 
> This patch changes the architectures to instead enable a Kconfig
> boolean, and then use that boolean in the generic Kconfig.debug
> to present the actual menu option.  This removes a bunch of
> duplication and adds consistency across arches.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Hirokazu Takata <takata@linux-m32r.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: uclinux-dist-devel@blackfin.uclinux.org

Reviewed-by: James Hogan <james.hogan@imgtec.com>

(I can use this for arch/metag too).

Cheers
James

