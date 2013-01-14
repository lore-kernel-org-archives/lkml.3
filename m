Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab3ANRMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:12:53 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60683 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668Ab3ANRMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:12:50 -0500
Message-ID: <50F43C5E.8030408@linux.vnet.ibm.com>
Date: Mon, 14 Jan 2013 09:11:58 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] consolidate per-arch stack overflow debugging options
References: <20130111170043.D7CC39DC@kernel.stglabs.ibm.com> <20130112120053.3362ae67bf2d3b2cc6042aa4@canb.auug.org.au>
In-Reply-To: <20130112120053.3362ae67bf2d3b2cc6042aa4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011417-7182-0000-0000-000004689900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 05:00 PM, Stephen Rothwell wrote:
> On Fri, 11 Jan 2013 09:00:43 -0800 Dave Hansen <dave@linux.vnet.ibm.com> wrote:
>>
>> I'm looking for some Acked-bys on this from the various arch
>> maintainers that it affects.  I'd like to send it up to Linus
>> in the next merge window.  This is part of a larger series to
>> clean up the "Kernel Hacking" menu:
>>
>> 	https://lkml.org/lkml/2012/12/17/306
> 
> This should be added to linux-next soon, if possible.  Either directly (if
> you have a tree I can fetch) or via some other maintainer's tree.

Hi Stephen,

I've got it stashed in here for the moment:

	https://github.com/hansendc/linux/tree/kconfig-reorg

It was forked off 3.8-rc2.

