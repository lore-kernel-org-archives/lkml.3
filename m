Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbaD2OPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:15:49 -0400
Received: from numascale.com ([213.162.240.84]:57826 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757771AbaD2OPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:15:46 -0400
X-Greylist: delayed 4058 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2014 10:15:46 EDT
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range capabilities
From: Steffen Persvold <sp@numascale.com>
In-Reply-To: <20140429102013.GA4726@pd.tnic>
Date: Tue, 29 Apr 2014 06:07:46 -0700
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Robert Richter <rric@kernel.org>,
        Myron Stowe <myron.stowe@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>, kim.naru@amd.com,
        Daniel J Blueman <daniel@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Yinghai Lu <yinghai@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <3CFA7164-1352-467D-951E-C9F8F35F3163@numascale.com>
References: <20140419025308.2408.51252.stgit@amt.stowe> <20140419025323.2408.88764.stgit@amt.stowe> <20140419135219.GC8109@pd.tnic> <20140420075936.GA19672@pd.tnic> <CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com> <20140426091031.GA10166@pd.tnic> <CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com> <20140428214036.GA32143@pd.tnic> <20140429073309.GE10997@alberich> <20140429102013.GA4726@pd.tnic>
To: Borislav Petkov <bp@suse.de>
X-Mailer: Apple Mail (2.1874)
X-OutGoing-Spam-Status: No, score=-2.9
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: sp+numascale.com/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Apr 2014, at 3:20 , Borislav Petkov <bp@suse.de> wrote:

> On Tue, Apr 29, 2014 at 09:33:09AM +0200, Andreas Herrmann wrote:
>> I am sure, it's because some server systems had MMIO ECS access not
>> enabled in BIOS. I can't remember which systems were affected.
> 
> Ok, now AMD people: what's the story with IO ECS, can we assume that on
> everything after F10h, BIOS has a sensible MCFG and we can limit this to
> F10h only? I like Bjorn's idea but we need to make sure a working MCFG
> is ubiquitous.
> 
> Which begs the real question: Suravee, why are you even touching IO ECS
> provided F15h and later have a MCFG? Or, do they?
> 

Our experience with this is that Fam10h and later have a very well working MCFG setup, earlier generations not so much (hence IO ECS was needed).

Cheers,
Steffen

