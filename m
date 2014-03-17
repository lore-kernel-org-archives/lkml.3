Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbaCQOh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:37:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:52553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaCQOh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:37:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] CNS3xxx: Fix PCIe early iotable_init().
Date: Mon, 17 Mar 2014 15:37:19 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Krzysztof =?utf-8?q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <anton@enomsg.org>, Yinghai Lu <yinghai@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arm@kernel.org
References: <m3eh2nqz7n.fsf@t19.piap.pl> <m3r46io1nd.fsf@t19.piap.pl> <m3eh2inxef.fsf@t19.piap.pl>
In-Reply-To: <m3eh2inxef.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201403171537.19546.arnd@arndb.de>
X-Provags-ID: V02:K0:8TA3rlE2rqAuE18RXytIDRVKsyK0hwUAXWrwU0ryjR3
 l8X4gCZrTREAx+OTon2vY5ufdDZfJ4NXad+y9gq2NgISJOCj0r
 WFXOECV6bfZ0I9PHgGispdizBxhfzqyoD3T4lId1bTHkCe2iAZ
 70Dy+T21INX+PWeRKFCFb/x6pB+nERxrikaXFXhXochPaKY3zg
 VP24OGMZJE2MXsndiQaz/QL+bfVh0+24kbaFG51WXhUalQSHCS
 H9F5PG7GvqeMw84Ijq0xGZoLs4KbDSPJgL+Bd3mWjWSHVvFYxh
 Js9BOahmSIssn/ayTpfcL41Pdt9Jx1Zl1bvMdYgVzhn563Y6iQ
 EORxEf1RWZhnrNzmXZ6NQOvzvFMFroNqA2HMGCpB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2014, Krzysztof Hałasa wrote:
> khalasa@piap.pl (Krzysztof Hałasa) writes:
> 
> > This patch fixes the following BUG:
> >
> >> kernel BUG at mm/vmalloc.c:1132!
> >> PC is at vm_area_add_early+0x20/0x84
> >> LR is at add_static_vm_early+0xc/0x60
> >>
> >> The problem is cns3xxx_pcie_init() (device_initcall) calls the "early"
> >> iotable_init().
> 
> That's obviously:
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> 

Applied to next/fixes-non-critical.

Since the problem is not new and you didn't mark the patch as 'stable',
this seems to be the right place. Let us know if you need backports
to stable kernels, also fo the other patch.

In general, when submitting arm-soc patches for inclusion, please add
arm@kernel.org to Cc, so we don't miss it.

Thanks,

	Arnd
