Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaANTTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:19:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55599 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbaANTTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:19:34 -0500
Message-ID: <52D58DA1.2070400@zytor.com>
Date: Tue, 14 Jan 2014 11:18:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Aravind.Gopalakrishnan@amd.com, tglx@linutronix.de, bp@suse.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode: Move to a proper location
References: <tip-bad5fa631fca5466401cd4a48e30cc1f1cb6101e@git.kernel.org> <52D56174.9010608@zytor.com> <20140114185802.GB29871@pd.tnic>
In-Reply-To: <20140114185802.GB29871@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 10:58 AM, Borislav Petkov wrote:
> On Tue, Jan 14, 2014 at 08:10:28AM -0800, H. Peter Anvin wrote:
>> Quite frankly I would be much happier if we didn't stash so much under
>> arch/x86/kernel/cpu ... quite frankly it feels like almost *anything*
>> could go under there. The microcode code, for example, could go under
>> its own subtree.
> 
> Yeah, about the microcode, shouldn't it be under kernel/cpu/? My train
> of thought is: because it is cpu-related functionality, it logically
> belongs there.

arch/x86/cpu/microcode seems clean.  I'm wondering if what is mostly
currently in arch/x86/kernel/cpu should be mostly in something like
arch/x86/cpu/init.

	-hpa



