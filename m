Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbaD3Jvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:51:37 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:42366 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbaD3Jve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:51:34 -0400
Date: Wed, 30 Apr 2014 11:51:29 +0200
From: Robert Richter <rric@kernel.org>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Myron Stowe <myron.stowe@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>, kim.naru@amd.com,
        Daniel J Blueman <daniel@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range
 capabilities
Message-ID: <20140430095129.GP32718@rric.localhost>
References: <20140426091031.GA10166@pd.tnic>
 <CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
 <20140428214036.GA32143@pd.tnic>
 <20140429073309.GE10997@alberich>
 <20140429102013.GA4726@pd.tnic>
 <535FC269.2000808@amd.com>
 <20140429191454.GB4726@pd.tnic>
 <CAL-B5D2Z7AvJZ3G2JLY6ZOZBRe4DGgO27RVJ_HHotGrnKL7Y1A@mail.gmail.com>
 <20140430070042.GN32718@rric.localhost>
 <5360AB3D.3020401@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5360AB3D.3020401@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.04.14 02:50:21, Suravee Suthikulpanit wrote:
> Actually, if ECS is needed by IBS, then wouldn't this still be needed for
> every family since 10h and later (except family11h).

Yes, but you have stated that pci mmconfig should work on families >
10h. Thus, ECS would work there out-of-the-box (at least after the
system brought pci up, ibs is initialized after pci setup).

-Robert
