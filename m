Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaLKENN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:13:13 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56274 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaLKENM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:13:12 -0500
Message-ID: <1418271187.5263.68.camel@marge.simpson.net>
Subject: Re: [tip:x86/apic] x86, PCI, ACPI: Kill private function
 resource_to_addr() in arch/x86/pci/acpi.c
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Thu, 11 Dec 2014 05:13:07 +0100
In-Reply-To: <CAE9FiQXBJABuH08GyE7qC2yRpU-mm8KVU5DA16uyq7Et4DctsQ@mail.gmail.com>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>
	 <tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
	 <CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
	 <alpine.DEB.2.11.1412101820510.13233@nanos>
	 <CAE9FiQW95VoJ35+KXOfV8eqFjSnhgkAqUmFWOKyKMwOAR_x7Kg@mail.gmail.com>
	 <20141211003507.GI17053@pd.tnic>
	 <CAE9FiQXBJABuH08GyE7qC2yRpU-mm8KVU5DA16uyq7Et4DctsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 17:57 -0800, Yinghai Lu wrote: 
> On Wed, Dec 10, 2014 at 4:35 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Wed, Dec 10, 2014 at 04:31:22PM -0800, Yinghai Lu wrote:
> >> > 2) Send patches inline. It's a pain to review and reply and I can't
> >> >    use my normal tooling.
> >>
> >> I can not, as gmail does not allow that.
> >
> > Lemme guess, this is some kind of a joke you're making, right?
> 
> I am using yhlu.kernel@gmail.com to send as yinghai@kernel.org.
> 
> Tried with mutt or thunderbird etc, all kept on downloading ....

All mail clients are sh*t :)

Evolution has it's annoyances too, but this ain't one of them.  I've set
up both imap and pop evolution accounts for gmail.  I generally only
enable the pop account, but can enable both simultaneously. 

-Mike

