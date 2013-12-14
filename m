Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3LNDN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:13:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:31343 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab3LNDN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:13:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,483,1384329600"; 
   d="scan'208";a="424537593"
Date: Fri, 13 Dec 2013 19:13:56 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC][PATCH 6/7] mm: slub: remove 'struct page' alignment
 restrictions
Message-ID: <20131214031356.GS22695@tassilo.jf.intel.com>
References: <20131213235903.8236C539@viggo.jf.intel.com>
 <20131213235911.79AA177D@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213235911.79AA177D@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> helps performance, presumably because of that 14% fewer
> cacheline effect.  A 30GB dd to a ramfs file:
> 
> 	dd if=/dev/zero of=bigfile bs=$((1<<30)) count=30
> 
> is sped up by about 4.4% in my testing.

Impressive result!

-Andi
