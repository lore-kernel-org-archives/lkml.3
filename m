Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3CNN1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:27:54 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41243 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3CNN1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130314131404.GH11631@dhcp22.suse.cz>
References: <1363114106-30251-1-git-send-email-gerald.schaefer@de.ibm.com>
	<1363114106-30251-2-git-send-email-gerald.schaefer@de.ibm.com>
	<20130314131404.GH11631@dhcp22.suse.cz>
Date: Thu, 14 Mar 2013 21:27:50 +0800
Message-ID: <CAJd=RBDz+02NeErMBVzi-EQSPwtK4zdUC=3gCB7iZKWVrgcbiA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/hugetlb: add more arch-defined huge_pte_xxx functions
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 9:14 PM, Michal Hocko <mhocko@suse.cz> wrote:
> Ouch, this adds a lot of code that is almost same for all archs except
> for some. Can we just make one common definition and define only those
> that differ, please?
>
Wonder if he is the guy that added THP for s390, which was a model
work in 2012.

Hillf
