Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3KRTeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:34:09 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41481 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3KRTeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:34:04 -0500
MIME-Version: 1.0
In-Reply-To: <20131118153211.GB32168@redhat.com>
References: <20131114180455.GA32212@anatevka.fc.hp.com>
	<CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
	<20131115005049.GJ5116@anatevka.fc.hp.com>
	<20131115062417.GB9237@gmail.com>
	<CAE9FiQWzSTtW8N=0hoUe6iCSM-k64Mv97n0whAS0_vZ+psuOsg@mail.gmail.com>
	<5285C639.5040203@zytor.com>
	<20131115140738.GB6637@redhat.com>
	<CAE9FiQUnw9Ujmdtq-AgC4VctQ=fZSBkzehoTbvw=aZeARL+pwA@mail.gmail.com>
	<20131115180324.GD6637@redhat.com>
	<CAE9FiQU_OstEq3VWwBB879O4EY0DE+zVWVens+w0MLFUQmr3sw@mail.gmail.com>
	<20131118153211.GB32168@redhat.com>
Date: Mon, 18 Nov 2013 11:34:04 -0800
X-Google-Sender-Auth: fUhAuV3AWtkOGCHn5KxmJkUZ7rE
Message-ID: <CAE9FiQWue3rBVTmXAMoBpWCTgFQ1VP+bkm-k_v1wx4U94ctPBA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Early use of boot service memory
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        jerry.hoemann@hp.com, Pekka Enberg <penberg@kernel.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "list@ebiederm.org:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 7:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> You may need bunch of PCIe cards installed.
>>
>> The system with 6TiB + 16 PCIe cards, second kernel OOM.
>> The system with 4.5TiB + 16 PCIe cards, second kernel works with vmcore dumped.
>
> What's the distro you are testing with? Do you have latest bits of
> makeudmpfile where we use cyclic mode by default and one does not need
> more reserved memory because of more physical memory present in the
> box. I suspect that might be the problem in your testing environment
> and old makedumpfile wil try to allocate larger memory on large
> RAM machines and OOM.

Default RHEL 6.4.

Will check if i can enable cyclic mode.

Thanks

Yinghai
