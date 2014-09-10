Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaIJRGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:06:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaIJRGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:06:35 -0400
Message-ID: <541084FE.6020408@redhat.com>
Date: Wed, 10 Sep 2014 19:06:06 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Sep 10 (bpf)
References: <20140910185920.336180d4@canb.auug.org.au> <5410815E.4080608@infradead.org>
In-Reply-To: <5410815E.4080608@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 06:50 PM, Randy Dunlap wrote:
> On 09/10/14 01:59, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20140909:
>
> When CONFIG_MODULES is not enabled:  (seen on i386 and x86_64)
>
> kernel/built-in.o: In function `bpf_jit_binary_alloc':
> (.text+0x7689d): undefined reference to `module_alloc'
> kernel/built-in.o: In function `bpf_jit_binary_free':
> (.text+0x768f0): undefined reference to `module_free'

[ Sorry for that, patch has already been submitted to netdev. ]
