Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3BDQ5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:57:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35192 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab3BDQ5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:57:35 -0500
Message-ID: <510FE7F5.3080802@zytor.com>
Date: Mon, 04 Feb 2013 08:55:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 4/4] x86, 32-bit: Drop new_cpu_data
References: <1359908079-10469-1-git-send-email-bp@alien8.de> <1359908079-10469-5-git-send-email-bp@alien8.de> <510EF65D.4020602@zytor.com> <20130204052725.GA13909@pd.tnic> <562c8dd4-6665-4365-8eb4-33e77e6f6798@email.android.com> <20130204090237.GB13909@pd.tnic>
In-Reply-To: <20130204090237.GB13909@pd.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 01:02 AM, Borislav Petkov wrote:
> On Sun, Feb 03, 2013 at 09:44:02PM -0800, H. Peter Anvin wrote:
>> boot_cpu_data is ok for things that are indeed universally valid
>> across. That does not include CPUID level, for one.
> 
> Wait a minute, hold the phone! :-)
> 
> Are you saying that CPUID_EAX(0) could return different values in %eax
> on the *same* system with mixed-silicon steppings? Or even on an uniform
> system?
> 

Yes and yes (in the latter case due to inconsistent MSR programming.)

	-hpa

