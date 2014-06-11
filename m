Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaFKBqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 21:46:13 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44991 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaFKBqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 21:46:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406110111300.5170@nanos>
References: <1402385723-23138-1-git-send-email-zhouzhouyi@gmail.com>
	<53978E9F.1010003@zytor.com>
	<alpine.DEB.2.10.1406110111300.5170@nanos>
Date: Wed, 11 Jun 2014 09:46:11 +0800
Message-ID: <CAABZP2xD4zRX78HxK1DB+13s+1bo=Ai2x+uJDhtJjb+nkZ7epQ@mail.gmail.com>
Subject: Re: [PATCH] x86/tlb_uv: Fixing some memory allocation failure in x86 UV
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, cpw@sgi.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing, I will work on a new version

On Wed, Jun 11, 2014 at 7:28 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 10 Jun 2014, H. Peter Anvin wrote:
>
>> On 06/10/2014 12:35 AM, Zhouyi Zhou wrote:
>> > Fixing some memory allocation failure handling in x86 UV
>> >
>> > Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
>>
>> Sorry, this really isn't enough description for this size of a patch.
>
> Correction: This is not a proper description for any patch.
>
> "some" is wrong to begin with.
>
> Either we fix a particular issue or we address all of them, but "some"
> means: We fixed a few, but we did not care about the rest.
>
> Aside of that, I agree. The changelog is disjunct from the patch
> itself.
>
> Thanks,
>
>         tglx
>
>
