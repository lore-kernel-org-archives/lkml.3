Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaKTKjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:39:46 -0500
Received: from mx0.aculab.com ([213.249.233.131]:37587 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755835AbaKTKjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:39:44 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mel Gorman'" <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        "Sasha Levin" <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>
Subject: RE: [PATCH 03/10] mm: Convert p[te|md]_numa users to
 p[te|md]_protnone_numa
Thread-Topic: [PATCH 03/10] mm: Convert p[te|md]_numa users to
 p[te|md]_protnone_numa
Thread-Index: AQHQBKvhmjjd2LiLyUSLGQ6oeihg2JxpUtlw
Date: Thu, 20 Nov 2014 10:38:56 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9F48CB@AcuExch.aculab.com>
References: <1416478790-27522-1-git-send-email-mgorman@suse.de>
 <1416478790-27522-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1416478790-27522-4-git-send-email-mgorman@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAKAdpu2009519

From:  Mel Gorman
> Convert existing users of pte_numa and friends to the new helper. Note
> that the kernel is broken after this patch is applied until the other
> page table modifiers are also altered. This patch layout is to make
> review easier.

Doesn't that break bisection?

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
