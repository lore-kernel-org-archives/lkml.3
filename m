Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab3FLJOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:14:36 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:37469 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3FLJOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:14:35 -0400
Date: Wed, 12 Jun 2013 11:14:22 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kexec@lists.infradead.org,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v5 5/5] s390/vmcore: Use vmcore for zfcpdump
Message-ID: <20130612111422.2a1d6889@holzheu>
In-Reply-To: <51B7B728.9000803@jp.fujitsu.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1370624161-2298-6-git-send-email-holzheu@linux.vnet.ibm.com>
	<51B7B728.9000803@jp.fujitsu.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061209-0342-0000-0000-0000054AD240
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013 08:47:52 +0900
HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

> (2013/06/08 1:56), Michael Holzheu wrote:
[snip]
> > +static int remap_oldmem_pfn_range_zfcpdump(struct vm_area_struct *vma,
> > +					   unsigned long from,
> > +					   unsigned long pfn,
> > +					   unsigned long size, pgprot_t prot)
> > +{
> > +	unsigned long size_hsa;
> > +
> > +	if (pfn < ZFCPDUMP_HSA_SIZE >> PAGE_SHIFT) {
> > +		size_hsa = min(size, OLDMEM_SIZE - (pfn << PAGE_SHIFT));
> 
> ZFCPDUMP_HSA_SIZE?

Correct!

Michael

