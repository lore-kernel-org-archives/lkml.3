Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3CMMFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:05:46 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:63327 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833Ab3CMMFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:05:44 -0400
Message-ID: <1363176339.1335.1.camel@x61.thuisdomein>
Subject: Re: [PATCH] decompressors: fix typo "POWERPC"
From: Paul Bolle <pebolle@tiscali.nl>
To: Lasse Collin <lasse.collin@tukaani.org>
Cc: Florian Fainelli <florian@openwrt.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Mar 2013 13:05:39 +0100
In-Reply-To: <20130313133045.51d44a63@tukaani.org>
References: <1363044544.3137.120.camel@x61.thuisdomein>
	 <20130313133045.51d44a63@tukaani.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2013 12:05:40.0054 (UTC) FILETIME=[14653F60:01CE1FE3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 13:30 +0200, Lasse Collin wrote:
> On 2013-03-12 Paul Bolle wrote:
> > 1) By the way: why does the XZ related code use both the macro
> > CONFIG_XZ_DEC_POWERPC and the macro XZ_DEC_POWERPC? (Ditto for other
> > architectures.) That looks odd.
> 
> In a preboot environment the options selected for the xz_dec module are
> ignored.

Naive question: what is a preboot environment?

> If XZ-compressed kernel is selected, lib/decompress_unxz.c
> will enable a BCJ filter for that architecture. An alternative could be
> to #undef the CONFIG_XZ_DEC_foo symbols in decompress_unxz.c and then
> #define what is needed for the selected architecture, but I think the
> current method is OK. See also lib/xz/xz_private.h.

Thanks,


Paul Bolle

