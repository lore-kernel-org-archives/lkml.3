Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbaDHVLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:11:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297AbaDHVLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:11:40 -0400
Date: Tue, 8 Apr 2014 17:11:08 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        aarcange@redhat.com, mgorman@suse.de, akpm@linux-foundation.org,
        andi@firstfloor.org, davidlohr@hp.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org, riel@redhat.com,
        n-horiguchi@ah.jp.nec.com
Subject: Re: [PATCH 3/5] hugetlb: update_and_free_page(): don't clear
 PG_reserved bit
Message-ID: <20140408171108.4faf41b7@redhat.com>
In-Reply-To: <20140408205126.GA2778@node.dhcp.inet.fi>
References: <1396983740-26047-1-git-send-email-lcapitulino@redhat.com>
	<1396983740-26047-4-git-send-email-lcapitulino@redhat.com>
	<20140408205126.GA2778@node.dhcp.inet.fi>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2014 23:51:26 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Tue, Apr 08, 2014 at 03:02:18PM -0400, Luiz Capitulino wrote:
> > Hugepages pages never get the PG_reserved bit set, so don't clear it. But
> > add a warning just in case.
> 
> I don't think WARN_ON() is needed. PG_reserved will be catched by
> free_pages_check().

Correct. I'll drop it.
