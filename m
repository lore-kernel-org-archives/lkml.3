Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaBYUfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:35:32 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:55003 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbaBYUfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:35:30 -0500
Message-ID: <530CFE7F.7030300@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 12:35:11 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 05/11] powerpc: add hv_gpci interface header
References: <20140225033328.1D5652C030B@ozlabs.org>
In-Reply-To: <20140225033328.1D5652C030B@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022520-8236-0000-0000-0000002A3F52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 07:33 PM, Michael Ellerman wrote:
> On Fri, 2014-14-02 at 22:02:09 UTC, Cody P Schafer wrote:
>> "H_GetPerformanceCounterInfo" (refered to as hv_gpci or just gpci from
>> here on) is an interface to retrieve specific performance counters and
>> other data from the hypervisor. All outputs have a fixed format (and
>> are represented as structs in this patch).
>
> I still see unused stuff in here, can you strip it back to just what we need.
> Same goes for the next patch.
>

Sure, I can remove the unused structures and enum entries (hadn't 
realized you wanted that in the last review).

