Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaKDRPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:15:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54484 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaKDRPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:15:35 -0500
X-AuditID: cbfee68e-f79b46d000002b74-be-545909b42ae2
From: PINTU KUMAR <pintu.k@samsung.com>
To: "'David Rientjes'" <rientjes@google.com>
Cc: akpm@linux-foundation.org, riel@redhat.com, aquini@redhat.com,
        paul.gortmaker@windriver.com, jmarchan@redhat.com,
        lcapitulino@redhat.com, kirill.shutemov@linux.intel.com,
        m.szyprowski@samsung.com, aneesh.kumar@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com, mina86@mina86.com, lauraa@codeaurora.org,
        gioh.kim@lge.com, mgorman@suse.de, hannes@cmpxchg.org, vbabka@suse.cz,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pintu_agarwal@yahoo.com, cpgs@samsung.com,
        vishnu.ps@samsung.com, rohit.kr@samsung.com, ed.savinay@samsung.com
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
 <1413986796-19732-1-git-send-email-pintu.k@samsung.com>
 <alpine.DEB.2.10.1411031556140.9845@chino.kir.corp.google.com>
In-reply-to: <alpine.DEB.2.10.1411031556140.9845@chino.kir.corp.google.com>
Subject: RE: [PATCH v2 1/2] mm: cma: split cma-reserved in dmesg log
Date: Tue, 04 Nov 2014 22:45:46 +0530
Message-id: <001a01cff853$04c90290$0e5b07b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIYigTjXepmiJMFsP3pxyBCbUOBxwLhW73LAmrDlwmblS/2MA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWyRsSkTncrZ2SIwdRj7BZz1q9hs3j8eh6L
	xYyHv1gsXh7StFi0ewGTxbOmL4wWqzf5WqzsbmazOPXnOpPFzedzWCy2d85gt+h//J3d4vKu
	OWwW99b8Z7VYe+Quu8Xkd88YLRYcb2G1uLb3OLPFt7e32S3+XlnPYtG2ZCOTxfPmVhaLxUdu
	M1vMbuxjtJjSd5fRQdLj8Jv3zB6X+3qZPBZsKvXY9GkSu0fX2ytMHidm/GbxmHcy0OPBoc0s
	Huv+vGLy+Pj0FovH+31X2Tz6tqxi9Diz4Ai7x+bT1R6fN8l5rN+ylSlAMIrLJiU1J7MstUjf
	LoEr4+vBH8wFS6QqbjxTaWDsFO1i5OSQEDCROHNuCiOELSZx4d56NhBbSGApo8S06+YwNQcu
	tbB0MXIBxaczSjzrmQrl/GaUeNJwhrmLkYODTUBd4tgBXpAGEQEtifs/F4MNZRbYySLx4EIa
	RP0+Ron3jRNZQOo5Bbwler55gdQIC7hInPi0jQnEZhFQldh8bhs7iM0rYCmx8dZLKFtQ4sfk
	eywQM7Uk1u88zgRhy0tsXvOWGeJQBYkdZ18zQtzgJLGw+QArRI24xKQHD9lBbpAQ2M4pcb/v
	JSPEMgGJb5MPgd0jISArsekA1BxJiYMrbrBMYJSYhWT1LCSrZyFZPQvJigWMLKsYRVMLkguK
	k9KLjPSKE3OLS/PS9ZLzczcxAlPa6X/P+nYw3jxgfYhRgINRiYc3QjIiRIg1say4MvcQoynQ
	RROZpUST84GJM68k3tDYzMjC1MTU2Mjc0kxJnDdB6mewkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBsaItz42zst8nExDr3M/NXm334FNOmFxwvwTp5USCo/6G0wqnBBqrnitlNNdPdQ5oMvZ
	Ofng9lL1OI3dH2d8PRAw+aLrtMOKkql9DtEtQcFFr23YN839PLm0rHxnZGMBu//rrNfOMlJ1
	cxf9Pe3ToeH3vMTX7evGrN8bbmm9inu6P+VuyKmyQCWW4oxEQy3mouJEAA07KmtkAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsVy+t9jQd0tnJEhBi8bLSzmrF/DZvH49TwW
	ixkPf7FYvDykabFo9wImi2dNXxgtVm/ytVjZ3cxmcerPdSaLm8/nsFhs75zBbtH/+Du7xeVd
	c9gs7q35z2qx9shddovJ754xWiw43sJqcW3vcWaLb29vs1v8vbKexaJtyUYmi+fNrSwWi4/c
	ZraY3djHaDGl7y6jg6TH4TfvmT0u9/UyeSzYVOqx6dMkdo+ut1eYPE7M+M3iMe9koMeDQ5tZ
	PNb9ecXk8fHpLRaP9/uusnn0bVnF6HFmwRF2j82nqz0+b5LzWL9lK1OAYFQDo01GamJKapFC
	al5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YOMEyUFMoSc0qBQgGJxcVK
	+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBlfD/5gLlgiVXHjmUoDY6doFyMnh4SAicSBSy0s
	ELaYxIV769m6GLk4hASmM0o865nKAuH8ZpR40nCGuYuRg4NNQF3i2AFekAYRAS2J+z8XM4LY
	zAI7WSQeXEiDqN/HKPG+cSILSD2ngLdEzzcvkBphAReJE5+2MYHYLAKqEpvPbWMHsXkFLCU2
	3noJZQtK/Jh8jwVippbE+p3HmSBseYnNa94yQxyqILHj7GtGiBucJBY2H2CFqBGXmPTgIfsE
	RqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnDKfSe1gXNlg
	cYhRgINRiYc3QjIiRIg1say4MvcQowQHs5IIr/pjoBBvSmJlVWpRfnxRaU5q8SFGU6BPJzJL
	iSbnA9N5Xkm8obGJuamxqaWJhYmZpZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkGRsVV1kl+
	Astd36zXmNPRPtGo6NhhixeVhubC6t7a36corH1VPWdDYpo0J6OWpuxLjTOv9Rdpft88P+lt
	/6c6vuUHK65aydjt3fpuzxp9A+dTD5yfxky2WfThraS0Lxenevch423XL+y0man4Ze6PTQwx
	l96vW9Y/27pT4lDJukPKzuXla2NmsyuxFGckGmoxFxUnAgARaroSrwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Tuesday, November 04, 2014 5:27 AM
> To: Pintu Kumar
> Cc: akpm@linux-foundation.org; riel@redhat.com; aquini@redhat.com;
> paul.gortmaker@windriver.com; jmarchan@redhat.com;
> lcapitulino@redhat.com; kirill.shutemov@linux.intel.com;
> m.szyprowski@samsung.com; aneesh.kumar@linux.vnet.ibm.com;
> iamjoonsoo.kim@lge.com; mina86@mina86.com; lauraa@codeaurora.org;
> gioh.kim@lge.com; mgorman@suse.de; hannes@cmpxchg.org; vbabka@suse.cz;
> sasha.levin@oracle.com; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> pintu_agarwal@yahoo.com; cpgs@samsung.com; vishnu.ps@samsung.com;
> rohit.kr@samsung.com; ed.savinay@samsung.com
> Subject: Re: [PATCH v2 1/2] mm: cma: split cma-reserved in dmesg log
> 
> On Wed, 22 Oct 2014, Pintu Kumar wrote:
> 
> > diff --git a/include/linux/cma.h b/include/linux/cma.h index
> > 0430ed0..0b75896 100644
> > --- a/include/linux/cma.h
> > +++ b/include/linux/cma.h
> > @@ -15,6 +15,7 @@
> >
> >  struct cma;
> >
> > +extern unsigned long totalcma_pages;
> >  extern phys_addr_t cma_get_base(struct cma *cma);  extern unsigned
> > long cma_get_size(struct cma *cma);
> >
> > diff --git a/mm/cma.c b/mm/cma.c
> > index 963bc4a..8435762 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -288,6 +288,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
> >  	if (ret)
> >  		goto err;
> >
> > +	totalcma_pages += (size / PAGE_SIZE);
> >  	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
> >  		(unsigned long)base);
> >  	return 0;
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c index dd73f9a..ababbd8
> > 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -110,6 +110,7 @@ static DEFINE_SPINLOCK(managed_page_count_lock);
> >
> >  unsigned long totalram_pages __read_mostly;  unsigned long
> > totalreserve_pages __read_mostly;
> > +unsigned long totalcma_pages __read_mostly;
> 
> Shouldn't this be __initdata instead?
> 

No, we wanted to retain this variable for later use. 
We wanted to use this to print CMA info in /proc/meminfo.
Please see the next patch for this set.
[PATCH v2 2/2] fs: proc: Include cma info in proc/meminfo


> >  /*
> >   * When calculating the number of globally allowed dirty pages, there
> >   * is a certain number of per-zone reserves that should not be @@
> > -5520,7 +5521,7 @@ void __init mem_init_print_info(const char *str)
> >
> >  	pr_info("Memory: %luK/%luK available "
> >  	       "(%luK kernel code, %luK rwdata, %luK rodata, "
> > -	       "%luK init, %luK bss, %luK reserved"
> > +	       "%luK init, %luK bss, %luK reserved, %luK cma-reserved"
> >  #ifdef	CONFIG_HIGHMEM
> >  	       ", %luK highmem"
> >  #endif
> > @@ -5528,7 +5529,8 @@ void __init mem_init_print_info(const char *str)
> >  	       nr_free_pages() << (PAGE_SHIFT-10), physpages << (PAGE_SHIFT-10),
> >  	       codesize >> 10, datasize >> 10, rosize >> 10,
> >  	       (init_data_size + init_code_size) >> 10, bss_size >> 10,
> > -	       (physpages - totalram_pages) << (PAGE_SHIFT-10),
> > +	       (physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT-10),
> > +	       totalcma_pages << (PAGE_SHIFT-10),
> >  #ifdef	CONFIG_HIGHMEM
> >  	       totalhigh_pages << (PAGE_SHIFT-10),  #endif

