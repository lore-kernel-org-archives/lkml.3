Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3KVBce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:32:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60255 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3KVBcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:32:32 -0500
Message-ID: <528EB40A.3040203@zytor.com>
Date: Thu, 21 Nov 2013 17:31:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, jerry.hoemann@hp.com,
        Vivek Goyal <vgoyal@redhat.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo.kernel.org@gmail.com>
Subject: Re: [RFC v2 0/2] Early use of boot service memory
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>	<20131121230744.GA31592@srcf.ucam.org>	<528E94D1.2050809@zytor.com>	<20131121233705.GA32121@srcf.ucam.org>	<528EAF99.1010503@zytor.com>	<20131122012524.GA5627@anatevka.fc.hp.com> <CAE9FiQUx5rnA0kpqXRQYtpj9Qk-4bPGaUKEbbF=XHsZbnSd6Rg@mail.gmail.com>
In-Reply-To: <CAE9FiQUx5rnA0kpqXRQYtpj9Qk-4bPGaUKEbbF=XHsZbnSd6Rg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 05:29 PM, Yinghai Lu wrote:
> On Thu, Nov 21, 2013 at 5:25 PM,  <jerry.hoemann@hp.com> wrote:
>> On Thu, Nov 21, 2013 at 05:12:57PM -0800, H. Peter Anvin wrote:
>>
>> Large systems w/ lots of IO require large crash kernel allocations for
>> the kernel to boot.  Then you have to worry about the OOM killer.....
> 
> so go with crashkernel=1024M,high.
> 

Yes, there is no bloody excuse to hog that much low memory.

	-hpa


