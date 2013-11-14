Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3KNSqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:46:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41920 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab3KNSqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:46:21 -0500
Message-ID: <52851A56.1040709@zytor.com>
Date: Thu, 14 Nov 2013 10:45:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>, Jerry Hoemann <jerry.hoemann@hp.com>
CC: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "list@ebiederm.org:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>	<d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>	<20131113224503.GB25344@anatevka.fc.hp.com>	<52840206.5020006@zytor.com>	<20131113235708.GC25344@anatevka.fc.hp.com>	<CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>	<20131114180455.GA32212@anatevka.fc.hp.com> <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
In-Reply-To: <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 10:44 AM, Pekka Enberg wrote:
> On Thu, Nov 14, 2013 at 8:04 PM,  <jerry.hoemann@hp.com> wrote:
>> Making this issue a quirk will be a lot more practical.  Its a small, focused
>> change whose implications are limited and more easily understood.
> 
> There's nothing practical with requiring users to pass a kernel option
> to make kdump work.  It's a workaround, sure, but it's not a proper
> fix.

And once you have to do that anyway, you might as well just do the kdump
load high...

	-hpa


