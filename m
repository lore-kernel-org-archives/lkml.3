Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3HUOW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:22:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40111 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab3HUOW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:22:56 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130821141926.GT18673@moon>
References: <5214C524.1050900@citrix.com> <dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com> <20130821141926.GT18673@moon>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with existing use
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 21 Aug 2013 16:22:21 +0200
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Message-ID: <4455be44-7daf-41f0-add6-087cf992868f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK now I'm confused.  I guess I shouldn't comment while on vacation and cache cold on everything.

Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>On Wed, Aug 21, 2013 at 04:11:25PM +0200, H. Peter Anvin wrote:
>>
>> Eep.  This should be reverted, indeed.  This isn't a manifest bug on
>!Xen but we
>> have gotten requests for WT support which would mean adding in the
>PAT but again.
>
>Please no, letme fix it. That's what I'm having in mind: don't use pse
>bit in swap
>entry but always mark page read from swap as dirty one (it's better
>than having
>no tracker at all and  will be the case on old machines with 32bit ptes
>only).

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
