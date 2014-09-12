Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaILRkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:40:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaILRkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:40:01 -0400
Message-ID: <54132FC9.5040201@redhat.com>
Date: Fri, 12 Sep 2014 19:39:21 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "zlim.lnx@gmail.com" <zlim.lnx@gmail.com>,
        "ast@plumgrid.com" <ast@plumgrid.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH arm64-next] net: bpf: arm64: address randomize and write
 protect JIT code
References: <1410505897-20122-1-git-send-email-dborkman@redhat.com> <20140912160345.GF5532@arm.com> <54131D87.9060008@redhat.com> <20140912164656.GH5532@arm.com> <54132A76.4070501@redhat.com> <20140912172151.GI5532@arm.com>
In-Reply-To: <20140912172151.GI5532@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 07:21 PM, Catalin Marinas wrote:
...
> We don't have a brk instruction for arm32 but we have guaranteed
> undefined space. Have a look at the kgdb support for example (or grep
> for register_undef_hook under arch/arm) to get an idea.

Will do, thanks!

>> Last but not least ;), if I would resend it today, would you queue
>> it for later on, or do you want to handle it differently?
>
> You can send it now, it will be pushed upstream at the right time.

Just did, thanks a lot for your help!
