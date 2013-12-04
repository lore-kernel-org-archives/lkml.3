Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab3LDTuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:50:11 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53868 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933117Ab3LDTuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:50:07 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 04/12] PCI: Destroy pci dev only once
Date: Wed, 04 Dec 2013 21:03:05 +0100
Message-ID: <1616994.RLUOIZgreK@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAE9FiQUURT40gXGFhPxqHvWTxVdWbm=70uh14U=dp=FgTOGt-g@mail.gmail.com>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org> <2691826.V0kc3nrim3@vostro.rjw.lan> <CAE9FiQUURT40gXGFhPxqHvWTxVdWbm=70uh14U=dp=FgTOGt-g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 03, 2013 06:19:28 PM Yinghai Lu wrote:
> On Sat, Nov 30, 2013 at 5:05 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Saturday, November 30, 2013 02:40:30 PM Yinghai Lu wrote:
> >
> > And this is not enough as I said, can you please stop ignoring me openly?
> >
> > You've already commented the last patch I posted, so why don't we finish
> > that discussion first?
> 
> No, i did not mean that.
> 
> I resent the whole patchset as I added pci_clip_resource() and that
> will need to revise several critial patches, and Bjorn does not like
> to have patches to be attached format.

I see.

> Also in the patcheset head mail, i did state that you have another
> solution using
> lock.
> 
> And your patch is quite big, please give me some time to digest it.

Yes, it is, please take your time. :-)

Thanks,
Rafael

