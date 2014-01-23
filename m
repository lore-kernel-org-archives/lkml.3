Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaAWCQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:16:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28547 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbaAWCQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:16:14 -0500
Message-ID: <52E07B63.1070400@oracle.com>
Date: Wed, 22 Jan 2014 21:16:03 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>,
        khlebnikov@openvz.org, Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG: Bad rss-counter state
References: <52E06B6F.90808@oracle.com> <alpine.DEB.2.02.1401221735450.26172@chino.kir.corp.google.com> <20140123015241.GA947@redhat.com>
In-Reply-To: <20140123015241.GA947@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 08:52 PM, Dave Jones wrote:
> Sasha, is this the current git tree version of Trinity ?
> (I'm wondering if yesterdays munmap changes might be tickling this bug).

Ah yes, my tree has the munmap patch from yesterday, which would explain why we
started seeing this issue just now.


Thanks,
Sasha
