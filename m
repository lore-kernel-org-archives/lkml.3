Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaBZG5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 01:57:00 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:59894 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaBZG47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 01:56:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140225221027.GB21559@pd.tnic>
References: <20140224162400.GE16457@pd.tnic>
	<20140224201943.GA4397@pd.tnic>
	<530CBB3D.3080604@zytor.com>
	<CABPqkBR4bR9U1bhTtA02gDVR0aZ7iXBfg87jPLHfhrZVeFF8_g@mail.gmail.com>
	<20140225163010.GG24636@pd.tnic>
	<CABPqkBT3O2VwV48OC9TgCLKrEnC_qokxU8_odMZQ+d+55wdKgA@mail.gmail.com>
	<20140225173946.GH24636@pd.tnic>
	<CABPqkBTk+KA2kd7Qge2SkNXebDoh9Ntc2L_E3p2k42sbMxoYXw@mail.gmail.com>
	<20140225221027.GB21559@pd.tnic>
Date: Wed, 26 Feb 2014 07:56:58 +0100
Message-ID: <CABPqkBSH-cHDZ16y0WMyJ2e-kmJ6G_8DkJXPDa7pc4Hp63xG4g@mail.gmail.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
From: Stephane Eranian <eranian@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        x86 <x86@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 25, 2014 at 11:10 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Feb 25, 2014 at 07:54:53PM +0100, Stephane Eranian wrote:
>
>> I am on tip.git at cfbf8d4 Linux 3.14-rc4.
>> and I don't see the problem (using Ubuntu Saucy).
>
> Also IVB, model 58?
>
Yes.

>> Given what you commented out, it seems like you're saying
>> something goes wrong with pci_get_device().
>
> Probably. I'll add some debug printk's tomorrow to shed some more light
> on the matter.
>
>> Am I missing some pm callbacks?
>
> Dunno. What do you mean by "pm callbacks" exactly? I don't know that
> code so I have to ask.
>
power management callbacks.

>> The uncore IMC is not used internally.
>
> By IMC I'm assuming this PIC dev:
>
> #define PCI_DEVICE_ID_INTEL_IVB_IMC     0x0154
>
> ?
>
Yes. Needs to point to the DRAM controller.

> And "internally" means by BIOS or something behind the curtains like
> SMM...?
>
I meant by the kernel.
