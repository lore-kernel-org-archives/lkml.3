Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3BKRWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:22:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38317 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879Ab3BKRWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:22:48 -0500
Message-ID: <511928B2.6000302@zytor.com>
Date: Mon, 11 Feb 2013 09:21:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/4] x86, head_32: Remove second CPUID detection from
 default_entry
References: <1360592538-10643-1-git-send-email-bp@alien8.de> <1360592538-10643-4-git-send-email-bp@alien8.de> <18557aed-383a-4454-8222-3d2c0f0a78be@email.android.com> <20130211171541.GD2683@pd.tnic>
In-Reply-To: <20130211171541.GD2683@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 09:15 AM, Borislav Petkov wrote:
> On Mon, Feb 11, 2013 at 07:49:14AM -0800, H. Peter Anvin wrote:
>> What about CPUs with inconsistent cpuid levels? Yes, they can and do
>> happen, as we discussed on IRC.
>
> Yes, this should still work. We're doing the EFLAGS.ID dance right at
> the beginning of default_entry on each cpu and cache cpuld level in
> new_cpu_data for the time we're in this code.
>
> What this particular patch removes is the yet-another EFLAGS.ID dance
> which we IMHO unnecessarily did after enabling paging.
>
> So basically nothing changes wrt handling inconsistent cpuid levels and
> MSR mis-programming - we still should be taking care of those cases.
>

Cool.  I misread your 0/4 cover and hadn't quite dug into the details yet.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

