Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbaGPOpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:45:19 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30121 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbaGPOpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:45:15 -0400
Message-ID: <1405521331.28702.57.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH 3/11] x86, mm, pat: Change reserve_memtype() to
 handle WT type
From: Toshi Kani <toshi.kani@hp.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>
Date: Wed, 16 Jul 2014 08:35:31 -0600
In-Reply-To: <CALCETrXMYmVkcpzwGEo=aUia6S9aOaODFR__Z54YUQAZ4rRhRA@mail.gmail.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
	 <1405452884-25688-4-git-send-email-toshi.kani@hp.com>
	 <CALCETrUPpP1Lo1gB_eTm6V3pJ3Fam-1gPZGKfksOXXGgtNGsEQ@mail.gmail.com>
	 <1405465801.28702.34.camel@misato.fc.hp.com>
	 <CALCETrUx+HkzBmTZo-BtOcOz7rs=oNcavJ9Go536Fcn2ugdobg@mail.gmail.com>
	 <1405468387.28702.53.camel@misato.fc.hp.com>
	 <CALCETrXMYmVkcpzwGEo=aUia6S9aOaODFR__Z54YUQAZ4rRhRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 17:28 -0700, Andy Lutomirski wrote:
> On Tue, Jul 15, 2014 at 4:53 PM, Toshi Kani <toshi.kani@hp.com> wrote:
 :
> > In this patch, I left using reserve_ram_pages_type() since I do not see
> > much reason to use WT for RAM, either.
> 
> I hereby predict that someone, some day, will build a system with
> nonvolatile "RAM", and someone will want this feature.  Just saying :)
> 
> More realistically, someone might want to write a silly driver that
> lets programs mmap some WT memory for testing.

Agreed.  This limitation needs to be addressed.  I meant to say that
this could be a separate effort.

Thanks,
-Toshi

