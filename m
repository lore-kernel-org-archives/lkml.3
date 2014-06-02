Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaFBVxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:53:40 -0400
Received: from www.sr71.net ([198.145.64.142]:41075 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaFBVxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:53:39 -0400
Message-ID: <538CF25E.8070905@sr71.net>
Date: Mon, 02 Jun 2014 14:53:34 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 00/10] mm: pagewalk: huge page cleanups and VMA passing
References: <20140602213644.925A26D0@viggo.jf.intel.com> <1401745925-l651h3s9@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1401745925-l651h3s9@n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 02:52 PM, Naoya Horiguchi wrote:
> What version is this patchset based on?
> Recently I comprehensively rewrote page table walker (from the same motivation
> as yours) and the patchset is now in linux-mm. I guess most of your patchset
> (I've not read them yet) conflict with this patchset.
> So could you take a look on it?

It's on top of a version of Linus's from the last week.  I'll take a
look at how it sits on top of -mm.
