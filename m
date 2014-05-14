Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbaENLWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbaENLWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:22:17 -0400
Message-ID: <537351DD.4010402@redhat.com>
Date: Wed, 14 May 2014 12:22:05 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, avagin@openvz.org,
        michael@ellerman.id.au, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] powerpc, ptrace: Enable support for transactional
 memory register sets
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com>	<1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com>	<537252C0.6090005@redhat.com>	<53730326.6000400@linux.vnet.ibm.com>	<53735044.5030008@redhat.com> <CAEjGV6y8-zOtOgxcg-6viNQh-RuzQCAy8JvJ+m-dc7XQnAkJmA@mail.gmail.com>
In-Reply-To: <CAEjGV6y8-zOtOgxcg-6viNQh-RuzQCAy8JvJ+m-dc7XQnAkJmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/14 12:18, Michael Neuling wrote:
> 
>> s390 actually screwed that, though it got away because
>> there's a bit in HWCAP to signal transactions support.  See:
>>
>>  https://sourceware.org/ml/gdb-patches/2013-11/msg00080.html
>>
>> Are you adding something to HWCAP too?
> 
> Yes but it's in HWCAP2

That's fine.

-- 
Pedro Alves

