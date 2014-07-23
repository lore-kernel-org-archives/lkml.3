Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaGWGNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:13:24 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58555 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaGWGNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:13:23 -0400
Message-ID: <53CF522E.9090408@gmail.com>
Date: Wed, 23 Jul 2014 11:41:58 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: filter: split filter.c into two files
References: <1406095319-3627-1-git-send-email-ast@plumgrid.com> <1406095319-3627-2-git-send-email-ast@plumgrid.com>
In-Reply-To: <1406095319-3627-2-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 11:31 AM, Alexei Starovoitov wrote:
> BPF is used in several kernel components. This split creates logical boundary
> between generic eBPF core and the rest
>
> kernel/bpf/core.c: eBPF interpreter
>
> net/core/filter.c: classic->eBPF converter, classic verifiers, socket filters
>
> This patch only moves functions.

If we are moving the code also its good to do cleanup.

Run checkpatch.pl on this...


-- 
Regards,
Varka Bhadram.

