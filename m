Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaAaU7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:59:18 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:35969 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaAaU7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:59:17 -0500
Message-ID: <52EC0E9B.8020406@linux.vnet.ibm.com>
Date: Fri, 31 Jan 2014 12:59:07 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 0/8] Add support for PowerPC Hypervisor supplied performance
 counters
References: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com> <1390354379.11104.3.camel@concordia> <52E05E49.3010903@linux.vnet.ibm.com>
In-Reply-To: <52E05E49.3010903@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14013120-1542-0000-0000-000005AEED25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 04:11 PM, Cody P Schafer wrote:
> On 01/21/2014 05:32 PM, Michael Ellerman wrote:
>> On Thu, 2014-01-16 at 15:53 -0800, Cody P Schafer wrote:
>>> These patches add basic pmus for 2 powerpc hypervisor interfaces to obtain
>>> performance counters: gpci ("get performance counter info") and 24x7.

Any comments on/things that need fixing for this patch set to be merged?

