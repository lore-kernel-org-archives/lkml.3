Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3FYBze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:55:34 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28928 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FYBzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:55:33 -0400
X-Spam-Score: -100.8
Message-ID: <51C8F861.9010101@asianux.com>
Date: Tue, 25 Jun 2013 09:54:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux390@de.ibm.com, cornelia.huck@de.ibm.com, mtosatti@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, linux-mm@kvack.org
Subject: [Suggestion] arch: s390: mm: the warnings with allmodconfig and "EXTRA_CFLAGS=-W"
References: <51C8F685.6000209@asianux.com>
In-Reply-To: <51C8F685.6000209@asianux.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

When allmodconfig for " IBM zSeries model z800 and z900"

It will report the related warnings ("EXTRA_CFLAGS=-W"):
  mm/slub.c:1875:1: warning: ‘deactivate_slab’ uses dynamic stack allocation [enabled by default]
  mm/slub.c:1941:1: warning: ‘unfreeze_partials.isra.32’ uses dynamic stack allocation [enabled by default]
  mm/slub.c:2575:1: warning: ‘__slab_free’ uses dynamic stack allocation [enabled by default]
  mm/slub.c:1582:1: warning: ‘get_partial_node.isra.34’ uses dynamic stack allocation [enabled by default]
  mm/slub.c:2311:1: warning: ‘__slab_alloc.constprop.42’ uses dynamic stack allocation [enabled by default]

Is it OK ?


Thanks.
--
Chen Gang

Asianux Corporation 
