Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaAPPgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:36:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbaAPPf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:35:59 -0500
Message-ID: <52D7FC59.1030702@suse.com>
Date: Thu, 16 Jan 2014 16:35:53 +0100
From: Michal Marek <mmarek@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Lee\, Chun-Yi" <joeyli.kernel@gmail.com>, dhowells@redhat.com
CC: linux-kernel@vger.kernel.org, Chun-Yi Lee <jlee@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] MODSIGN: Fix including certificate twice when the signing_key.x509
References: <1389249983-31265-1-git-send-email-jlee@suse.com> <87eh49x3hh.fsf@rustcorp.com.au>
In-Reply-To: <87eh49x3hh.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.1.2014 05:39, Rusty Russell wrote:
> "Lee, Chun-Yi" <joeyli.kernel@gmail.com> writes:
>> From: Chun-Yi Lee <jlee@suse.com>
>> v2:
>> Using '$(shell /bin/pwd)' instead of '$(shell pwd)' for more reliable
>> between different shells
> 
> Hmm, that's not a great test for equality.  How about:
> 
>      ifneq ($(realpath .), $(realpath $(srctree)))
> 
> That should cover all the cases.

make 3.80 does not have realpath :(.

Michal

