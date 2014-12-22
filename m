Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaLVUip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:38:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25786 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaLVUio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:38:44 -0500
Message-ID: <54988142.40207@oracle.com>
Date: Mon, 22 Dec 2014 15:38:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mm: NULL ptr deref in unlink_file_vma
References: <549832E2.8060609@oracle.com>	 <20141222180102.GA8072@node.dhcp.inet.fi>	 <20141222180420.GA20261@node.dhcp.inet.fi> <1419275072.8812.1.camel@stgolabs.net>
In-Reply-To: <1419275072.8812.1.camel@stgolabs.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 02:04 PM, Davidlohr Bueso wrote:
> Sasha, does this still occur if you revert c8475d144abb?

On 12/22/2014 02:14 PM, Kirill A. Shutemov wrote:
> Sasha could you check if you hit untrack_pfn()?

I'm afraid I only hit this issue once, unlike the other once which
was bisected down.

I'm trying to play with it a bit to see if I can "help" it reproduce,
but no luck so far.


Thanks,
Sasha
