Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaAIIfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:35:19 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:51558 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaAIIfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:35:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140108161936.d42bd6f7f5af528a841041d6@linux-foundation.org>
References: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com>
	<20140106073549.GA25771@lge.com>
	<alpine.LRH.2.02.1401061237120.6190@file01.intranet.prod.int.rdu2.redhat.com>
	<20140107014159.GA26726@lge.com>
	<52CDBD94.9090808@gmx.de>
	<CAOJsxLGJbRrDOesdSFnYCt9GOyTGEF0TDWNux06C3OxJnuLFMg@mail.gmail.com>
	<20140108135930.9fc1d3a63eeb9a45dcbbb2e8@linux-foundation.org>
	<20140109001331.GA15738@lge.com>
	<20140108161936.d42bd6f7f5af528a841041d6@linux-foundation.org>
Date: Thu, 9 Jan 2014 10:35:12 +0200
X-Google-Sender-Auth: qD18eD32-NWyO7WG6juzvWJSG9Q
Message-ID: <CAOJsxLF76+LhZ25hLqi7zgTbSuCR91nM8DW5Pv7MCvDymj1Tyg@mail.gmail.com>
Subject: Re: [PATCH] fix crash when using XFS on loopback
From: Pekka Enberg <penberg@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Helge Deller <deller@gmx.de>,
        Mikulas Patocka <mpatocka@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 2:19 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> cache-misses are reduced by this patchset, roughly 5%.
>> And elapsed times are also improved by 3.1% to baseline.
>
> ah, OK, thanks, useful.  A few instructions added to page_mapping()
> won't have effects like that!

Yup, I merged the series because the numbers were so impressive.

There's a link to the cover letter in merge commit 24f971a but it
would have been better to include them in the changelog itself.

                     Pekka
