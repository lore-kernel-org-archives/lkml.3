Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaILUWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:22:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20305 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaILUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:22:10 -0400
Date: Fri, 12 Sep 2014 16:21:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [PATCH 1/5] x86, mm, pat: Set WT to PA4 slot of PAT MSR
Message-ID: <20140912202138.GA24501@laptop.dumpdata.com>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
 <1409855739-8985-2-git-send-email-toshi.kani@hp.com>
 <20140904201123.GA9116@khazad-dum.debian.net>
 <5408C9C4.1010705@zytor.com>
 <20140904231923.GA15320@khazad-dum.debian.net>
 <CALCETrWxKFtM8FhnHQz--uaHYbiqShE1XLJxMCKN7Rs4SO14eQ@mail.gmail.com>
 <20140912192501.GG15656@laptop.dumpdata.com>
 <CALCETrU5r8r-RZ82yXd+Tfrhfz=CfdmCwh4A559kTVcDXFR5jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU5r8r-RZ82yXd+Tfrhfz=CfdmCwh4A559kTVcDXFR5jQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 01:03:12PM -0700, Andy Lutomirski wrote:
> On Fri, Sep 12, 2014 at 12:25 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Thu, Sep 04, 2014 at 04:34:43PM -0700, Andy Lutomirski wrote:
> >> At the very least, anyone who plugs an NV-DIMM into a 32-bit machine
> >> is nuts, and not just because I'd be somewhat amazed if it even
> >> physically fits into the slot. :)
> >
> > They do have PCIe to PCI adapters, so you _could_ do it :-)
> >
> 
> My NV-DIMMs are DDR3 RDIMMs, so it would be a very magical adapter indeed.

I misread that as 'NVME', duh!

> 
> --Andy
