Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaAPAce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:32:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaAPAcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:32:32 -0500
Date: Wed, 15 Jan 2014 16:32:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Matt Mackall <mpm@selenic.com>,
        Cliff Wickman <cpw@sgi.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Rik van Riel <riel@redhat.com>,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11 v4] update page table walker
Message-Id: <20140115163230.fdf99574f0e1b0cf97d5cf07@linux-foundation.org>
In-Reply-To: <1389632051-25159-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1389632051-25159-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan 2014 11:54:00 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> This is ver.4 of page table walker patchset.
> I rebased it onto mmotm-2014-01-09-16-23, refactored, and commented more.
> Changes since ver.3 are only on 1/11 and 2/11.

Looks good to me.

Patch [1/11] breaks the build ("mm/pagewalk.c:201: error: 'hmask'
undeclared") and [10/11] fixes that up.

Please resend everything after 3.14-rc1?
