Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3AYIVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:21:30 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:44807 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab3AYIV3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 25 Jan 2013 03:21:29 -0500
Message-Id: <51024E9602000078000B97A2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 25 Jan 2013 08:21:26 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, "Ingo Molnar" <mingo@kernel.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3, v2] x86: xor-block handling adjustments
References: <5093E40902000078000A6147@nat28.tlf.novell.com>
 <20130124171554.GC11772@gmail.com> <51017028.3020001@zytor.com>
In-Reply-To: <51017028.3020001@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.01.13 at 18:32, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 01/24/2013 11:15 AM, Ingo Molnar wrote:
>> 
>> * Jan Beulich <JBeulich@suse.com> wrote:
>> 
>>> v2 of this series is merely updated on top of the changes between
>>> 3.6 and 3.7-rc (which includes the dropping of what previously was
>>> the second patch in a four patch series).
>>>
>>> 1: unify SSE-base xor-block routines
>>> 2: add alternative SSE implementation only prefetching once per 64-byte line
>>> 3: make virtualization friendly
>>>
>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> 
>> Looks useful. Wondering what the status is: hpa, was your 
>> concern resolved, do you think we can apply these?
>> 
> 
> I don't see anything wrong, except that I can't *find* patch 3/3 either
> in my inbox nor on LKML...

I can certainly resend the whole set, but our email system even
got a delivery confirmation from yours on patch 3 (other than
e.g. from Ingo's, and all of this identical to 0...2).

Or see https://patchwork.kernel.org/patch/1688991/, according
to which you even responded to it (which is the concern Ingo was
referring to).

Jan

