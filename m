Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaAVPVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:21:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35741 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbaAVPVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:21:08 -0500
Message-ID: <52DFE1C9.9000406@zytor.com>
Date: Wed, 22 Jan 2014 07:20:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] Use __kernel_ulong_t in x86 struct semid64_ds
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com> <1388165112-6545-7-git-send-email-hjl.tools@gmail.com> <20140121171053.GD20798@arm.com> <CAMe9rOoKvJNkhHLwF+gfX1T8M=ekBvCJn7PJ61U9-_OvcB-tKQ@mail.gmail.com> <20140122145747.GC8065@arm.com>
In-Reply-To: <20140122145747.GC8065@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 06:57 AM, Catalin Marinas wrote:
> 
> Thanks, very useful. We'll give it a try when we get there. So far I
> NAK'ed the first set of arm64 ILP32 patches as they were mostly using
> the compat ABI (https://lkml.org/lkml/2013/9/9/502).
> 

That's mostly where we started out, too.

	-hpa

