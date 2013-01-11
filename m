Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3AKRgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:36:51 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:27419 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3AKRgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:36:49 -0500
Message-ID: <50F04DAF.5040104@tilera.com>
Date: Fri, 11 Jan 2013 12:36:47 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH] consolidate per-arch stack overflow debugging options
References: <20130111170043.D7CC39DC@kernel.stglabs.ibm.com>
In-Reply-To: <20130111170043.D7CC39DC@kernel.stglabs.ibm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/11/2013 12:00 PM, Dave Hansen wrote:
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

Acked-by: Chris Metcalf <cmetcalf@tilera.com> [for tile]

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

