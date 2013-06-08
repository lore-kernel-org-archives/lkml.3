Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab3FHI0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 04:26:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17024 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3FHI0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 04:26:04 -0400
X-Spam-Score: -100.8
Message-ID: <51B2EA68.9000201@asianux.com>
Date: Sat, 08 Jun 2013 16:25:12 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, shli@fusionio.com,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: x86: include: asm: need 'unsigned' type cast for
 atomic_clear_mask()
References: <51B2CF75.1090207@asianux.com> <51B2DDC7.4070107@zytor.com> <51B2E4FD.4000708@asianux.com>
In-Reply-To: <51B2E4FD.4000708@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2013 04:02 PM, Chen Gang wrote:
> On 06/08/2013 03:31 PM, H. Peter Anvin wrote:
>> > On 06/07/2013 11:30 PM, Chen Gang wrote:
>>>> >> > 
>>>> >> > atomic_set_mask() has already have 'unsigned' type case, and
>>>> >> > atomic_clear_mask() is the pair of atomic_set_mask().
>>>> >> > 
>>>> >> > So it also need 'unsigned' type case.
>>>> >> > 
>> > Pray tell, in what situation does this matter?  The only reason I can
>> > think of is if "mask" is actually a long...
> Excuse me, in fact, I don't know whether it will cause issue. Since
> atomic_set_mask() has done, I think atomic_clear_mask() also need it.
> 
> If atomic_clear_mask() do need it, the atomic_set_mask() do not need it
> either, they are the pairs --> they will face the same situation.

Oh, my typo, it should be "If atomic_clear_mask() do not need it, the
atomic_set_mask() do not need it either, the are face same situation".


Thanks.
-- 
Chen Gang

Asianux Corporation
