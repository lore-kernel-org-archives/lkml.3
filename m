Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaANTc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:32:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55788 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaANTcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:32:53 -0500
Message-ID: <52D590C9.1070602@zytor.com>
Date: Tue, 14 Jan 2014 11:32:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Aravind.Gopalakrishnan@amd.com, tglx@linutronix.de, bp@suse.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode: Move to a proper location
References: <tip-bad5fa631fca5466401cd4a48e30cc1f1cb6101e@git.kernel.org> <52D56174.9010608@zytor.com> <20140114185802.GB29871@pd.tnic> <52D58DA1.2070400@zytor.com> <20140114192702.GN29865@pd.tnic>
In-Reply-To: <20140114192702.GN29865@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 11:27 AM, Borislav Petkov wrote:
> On Tue, Jan 14, 2014 at 11:18:57AM -0800, H. Peter Anvin wrote:
>> arch/x86/cpu/microcode seems clean. I'm wondering if what is mostly
>> currently in arch/x86/kernel/cpu should be mostly in something like
>> arch/x86/cpu/init.
> 
> Yeah, I can start reorganizing stuff slowly and with time, the best
> place will dawn on us. One thing's for sure, the "kernel" in the path is
> kinda redundant because, as Ingo said, it is all kernel.
> 

Indeed.

	-hpa

