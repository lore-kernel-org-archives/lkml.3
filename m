Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaJQUYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:24:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48052 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbaJQUYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:24:13 -0400
Message-ID: <54417AC7.7050605@zytor.com>
Date: Fri, 17 Oct 2014 13:23:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH 1/4 linux-next] x86, msr: define msr chunksize
References: <1413576089-27014-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1413576089-27014-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 01:01 PM, Fabian Frederick wrote:
> define MSR_CHUNK_SIZE instead of hard-coded value (8).
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

I don't like the name, as it isn't a "chunk" but the actual width of an MSR.

Furthermore, the last hunk is just plain wrong; the 8 there refers to
the number of registers and not to the width of an MSR.

	-hpa

