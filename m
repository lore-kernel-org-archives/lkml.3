Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaDAPr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:47:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50391 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaDAPr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:47:27 -0400
Message-ID: <533ADF86.1080209@oracle.com>
Date: Tue, 01 Apr 2014 11:47:18 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, Robin Hack <rhack@redhat.com>
CC: Eunbong Song <eunb.song@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: tools/liblockdep: Build failure
References: <22212997.138341396332274687.JavaMail.weblogic@epml01> <20140401080258.GA10429@bigoook.brq.redhat.com> <20140401081144.GB10429@bigoook.brq.redhat.com> <20140401102159.GC10429@bigoook.brq.redhat.com> <20140401153453.GK32556@tassilo.jf.intel.com>
In-Reply-To: <20140401153453.GK32556@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 11:34 AM, Andi Kleen wrote:
> On Tue, Apr 01, 2014 at 12:21:59PM +0200, Robin Hack wrote:
>> From: Robin Hack <rhack@redhat.com>
>> Copy asmlinkage macro to lockdep/uinclude/linux/linkage.h.
>
> You can just do
>
> #define asmlinkage
> #define __visible

Thanks Andi,

I've queued it up along with another fix for Ingo.


Thanks,
Sasha

