Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3LZNyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 08:54:12 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:65208 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3LZNyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 08:54:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAMe9rOqx1HDT_rtiz2R0Cz5iAp0AFXhjw6RpTkjgFT_DDDWfVA@mail.gmail.com>
References: <20131225145447.GA18146@gmail.com>
	<20131226100348.GA7751@infradead.org>
	<CAMe9rOqx1HDT_rtiz2R0Cz5iAp0AFXhjw6RpTkjgFT_DDDWfVA@mail.gmail.com>
Date: Thu, 26 Dec 2013 05:54:10 -0800
Message-ID: <CAMe9rOq8uNiHkG-n_mFZNeXbvFkMRJ1SCp=wtyPAhtjeOnic+A@mail.gmail.com>
Subject: Re: [PATCH] Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 5:52 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
> On Thu, Dec 26, 2013 at 2:03 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Wed, Dec 25, 2013 at 06:54:47AM -0800, H.J. Lu wrote:
>>> Both x32 and x86-64 use the same struct rusage and struct rlimit for
>>> system calls.  But x32 log is 32-bit.  This patch change uapi
>>> <linux/resource.h> to use __kernel_long_t in struct rusage and
>>> __kernel_ulong_t in and struct rlimit.
>>
>>  a) please send all your related patches as a series
>
> My patches are independent of each other.  They can
> be applied in order.
>

I meant to say "they can be applied in any order."


-- 
H.J.
