Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab3FJIAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:00:14 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:52968 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3FJIAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:00:12 -0400
Date: Mon, 10 Jun 2013 10:00:00 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Maxim Uvarov <muvarov@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v5 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Message-ID: <20130610100000.23743ea1@holzheu>
In-Reply-To: <CAJGZr0+_W0dp2f9VtVAiUT2fqiwe91gHXd9zYzfMMzBZSZogww@mail.gmail.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1370624161-2298-4-git-send-email-holzheu@linux.vnet.ibm.com>
	<CAJGZr0+_W0dp2f9VtVAiUT2fqiwe91gHXd9zYzfMMzBZSZogww@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061007-0542-0000-0000-0000057E6719
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Jun 2013 11:38:00 +0400
Maxim Uvarov <muvarov@gmail.com> wrote:

[snip]

> > +static int copy_to(void *target, void *src, size_t size, int
> > userbuf) +{
> > +       if (userbuf) {
> > +               if (copy_to_user(target, src, size))
> > +                       return -EFAULT;
> > +               return 0;
> > +       } else {
> > +               memcpy(target, src, size);
> > +               return 0;
> > +       }
> > +}
> >  
> 
> It is better to do return 0 in the end of function.

Sure, I will change that.

Thanks!
Michael

