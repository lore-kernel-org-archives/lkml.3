Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935258Ab3DJH4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:56:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab3DJH43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:56:29 -0400
Message-ID: <51651B2B.90206@suse.cz>
Date: Wed, 10 Apr 2013 09:56:27 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: generate generic headers before recursing into
 scripts
References: <CA+V-a8vYsBLVH-3Bm35Sv9K9ZMTcMB4_P_V3kBjyuEKDozPi5w@mail.gmail.com> <1363949290.3528.37.camel@linaro1.home> <m2ip48d62f.fsf@igel.home> <CA+V-a8srtwdf1H2JQwbkyMFhXopPEA90RM8Hy+UunM6Mm7-d1w@mail.gmail.com> <m2k3ob1tar.fsf_-_@igel.home>
In-Reply-To: <m2k3ob1tar.fsf_-_@igel.home>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.4.2013 19:57, Andreas Schwab wrote:
> The headers are now needed inside scripts/mod since 6543bec
> ("mod/file2alias: make modalias generation safe for cross compiling").
> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
> Prabhakar Lad <prabhakar.csengg@gmail.com> writes:
> 
>> Whats the status of it ?
> 
> I think it has sufficiently been tested by now.

Thanks a lot, I added it to kbuild.git#rc-fixes.

Michal

