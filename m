Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936202Ab3DILeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:34:04 -0400
Received: from numascale.com ([213.162.240.84]:36890 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935236Ab3DILeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:34:03 -0400
Message-ID: <5163FCA9.1020403@numascale.com>
Date: Tue, 09 Apr 2013 13:34:01 +0200
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
References: <1365090720-12652-1-git-send-email-daniel@numascale-asia.com> <20130404161340.GF32271@pd.tnic> <515DC0FA.1040408@numascale.com> <20130404190731.GG32271@pd.tnic> <5163DE7C.7060700@numascale.com> <20130409093854.GC10243@pd.tnic> <5163E348.7060206@numascale.com> <20130409102409.GF10243@pd.tnic>
In-Reply-To: <20130409102409.GF10243@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: sp@numascale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/2013 12:24 PM, Borislav Petkov wrote:
> On Tue, Apr 09, 2013 at 11:45:44AM +0200, Steffen Persvold wrote:
>> Hmm, yes of course. This of course breaks on our slave servers when
>> the shared mechanism doesn't work properly (i.e NB not visible). Then
>> all cores gets individual kobjects and there can be discrepancies
>> between what the hardware is programmed to and what is reflected in
>> /sys on some cores..
>
> Hold on, are you saying you have cores with an invisible NB? How does
> that even work? Or is it only invisible to sw?

only invisible to the kernel because the multi-pci-domains isn't working 
pre 3.9 on our architecture.

cheers,
Steffen
