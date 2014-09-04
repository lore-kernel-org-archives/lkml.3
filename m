Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaIDTHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:07:37 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:42347 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaIDTHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:07:35 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2014 15:07:35 EDT
Message-ID: <1409857025.28990.125.camel@misato.fc.hp.com>
Subject: Re: [PATCH 4/5] x86, mm: Add set_memory_wt() for WT
From: Toshi Kani <toshi.kani@hp.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, akpm@linuxfoundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 04 Sep 2014 12:57:05 -0600
In-Reply-To: <CALCETrXjpoVmCi07zo0dKH9LrF+nz9F3GshNiQvmiueFFH=TUQ@mail.gmail.com>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
	 <1409855739-8985-5-git-send-email-toshi.kani@hp.com>
	 <CALCETrXjpoVmCi07zo0dKH9LrF+nz9F3GshNiQvmiueFFH=TUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 11:57 -0700, Andy Lutomirski wrote:
> On Thu, Sep 4, 2014 at 11:35 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > This patch adds set_memory_wt(), set_memory_array_wt(), and
> > set_pages_array_wt() for setting range(s) of memory to WT.
> >
> 
> Possibly dumb question: I thought that set_memory_xyz was only for
> RAM.  Is that incorrect?

It works for non-RAM ranges as well.  For instance, you can use
set_memory_xyz() to change cache attribute for a non-RAM range mapped by
ioremap_cache().

Thanks,
-Toshi



