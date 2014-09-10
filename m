Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaIJUsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:48:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaIJUsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:48:04 -0400
Date: Wed, 10 Sep 2014 16:47:24 -0400
From: Dave Jones <davej@redhat.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC/PATCH v2 10/10] lib: add kasan test module
Message-ID: <20140910204724.GA11363@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Ryabinin <a.ryabinin@samsung.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Konstantin Serebryany <kcc@google.com>,
	Dmitry Chernenkov <dmitryc@google.com>,
	Andrey Konovalov <adech.fo@gmail.com>,
	Yuri Gribov <tetra2005@gmail.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Christoph Lameter <cl@linux.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Andi Kleen <andi@firstfloor.org>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-11-git-send-email-a.ryabinin@samsung.com>
 <20140910203814.GA10244@redhat.com>
 <CAPAsAGxwPZ_Qn_4d8hGcjcz1ZSN5-2qqqjqJhDPmv7NKq9=x+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPAsAGxwPZ_Qn_4d8hGcjcz1ZSN5-2qqqjqJhDPmv7NKq9=x+Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:46:04AM +0400, Andrey Ryabinin wrote:
 > 2014-09-11 0:38 GMT+04:00 Dave Jones <davej@redhat.com>:
 > > On Wed, Sep 10, 2014 at 06:31:27PM +0400, Andrey Ryabinin wrote:
 > >  > This is a test module doing varios nasty things like
 > >  > out of bounds accesses, use after free. It is usefull for testing
 > >  > kernel debugging features like kernel address sanitizer.
 > >
 > >  > +void __init kmalloc_oob_rigth(void)
 > >  > +{
 > >
 > > 'right' ?
 > >
 > >
 > 
 > I mean to the right side here (opposite to left), not synonym of  word
 > 'correct'.

yes, but there's a typo.

	Dave
