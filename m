Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3KVCnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:43:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60886 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab3KVCnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:43:02 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131122023406.GG31921@redhat.com>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com> <20131121230744.GA31592@srcf.ucam.org> <528E94D1.2050809@zytor.com> <20131121233705.GA32121@srcf.ucam.org> <528EAF99.1010503@zytor.com> <20131122012524.GA5627@anatevka.fc.hp.com> <CAE9FiQUx5rnA0kpqXRQYtpj9Qk-4bPGaUKEbbF=XHsZbnSd6Rg@mail.gmail.com> <528EB40A.3040203@zytor.com> <20131122023406.GG31921@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC v2 0/2] Early use of boot service memory
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 21 Nov 2013 18:42:14 -0800
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, jerry.hoemann@hp.com,
        Matthew Garrett <mjg59@srcf.ucam.org>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo.kernel.org@gmail.com>
Message-ID: <e48c784c-a7e3-4aca-a2e8-3e9591bbaf98@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various DMA-deficient devices, at least without an iommu.

Vivek Goyal <vgoyal@redhat.com> wrote:
>On Thu, Nov 21, 2013 at 05:31:54PM -0800, H. Peter Anvin wrote:
>> On 11/21/2013 05:29 PM, Yinghai Lu wrote:
>> > On Thu, Nov 21, 2013 at 5:25 PM,  <jerry.hoemann@hp.com> wrote:
>> >> On Thu, Nov 21, 2013 at 05:12:57PM -0800, H. Peter Anvin wrote:
>> >>
>> >> Large systems w/ lots of IO require large crash kernel allocations
>for
>> >> the kernel to boot.  Then you have to worry about the OOM
>killer.....
>> > 
>> > so go with crashkernel=1024M,high.
>> > 
>> 
>> Yes, there is no bloody excuse to hog that much low memory.
>
>Curious, why is low memory precious on x86_64? Who is going to use it?
>
>Thanks
>Vivek

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
