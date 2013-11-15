Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab3KOIgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:36:49 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54769 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab3KOIgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:36:41 -0500
X-Sasl-enc: sPk7mwHRsCfE30UIoaW/OVm6E/7dAqPWwav5vfZgkdZ3 1384504600
Message-ID: <5285DD15.6080700@iki.fi>
Date: Fri, 15 Nov 2013 10:36:37 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: jerry.hoemann@hp.com, Pekka Enberg <penberg@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "list@ebiederm.org:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com> <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com> <20131113224503.GB25344@anatevka.fc.hp.com> <52840206.5020006@zytor.com> <20131113235708.GC25344@anatevka.fc.hp.com> <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com> <20131114180455.GA32212@anatevka.fc.hp.com> <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com> <20131115005049.GJ5116@anatevka.fc.hp.com>
In-Reply-To: <20131115005049.GJ5116@anatevka.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/13 2:50 AM, jerry.hoemann@hp.com wrote:
> One already has to specify command line arguments to enable kdump.

Yes, so what?

The problem with your patch is that now to enable kdump, I have to know 
that there's a second command line option and if my firmware is "broken" 
or not.  The former is already a problem (how do I even know such a 
thing exists?) but the latter is almost impossible to solve from user 
point of view. And if I have a "broken" firmware, kdump won't work no 
matter what options I pass.

I really don't see what's practical about that.

                         Pekka
