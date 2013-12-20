Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab3LTLIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:08:22 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60765 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab3LTLIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:08:21 -0500
Message-ID: <52B424CF.3030809@linux.vnet.ibm.com>
Date: Fri, 20 Dec 2013 16:36:55 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        ak@linux.intel.com, eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH V4 10/10] powerpc, perf: Cleanup SW branch filter list
 look up
References: <20131209062147.B874D2C00C6@ozlabs.org>
In-Reply-To: <20131209062147.B874D2C00C6@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122011-4790-0000-0000-00000BE4286B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 11:51 AM, Michael Ellerman wrote:
> On Wed, 2013-04-12 at 10:32:42 UTC, Anshuman Khandual wrote:
>> This patch adds enumeration for all available SW branch filters
>> in powerpc book3s code and also streamlines the look for the
>> SW branch filter entries while trying to figure out which all
>> branch filters can be supported in SW.
> 
> This appears to patch code that was only added in 8/10 ?
> 
> Was there any reason not to do it the right way from the beginning?

No reason, merged this into the 8/10th patch. Working on the V5 of
this patchset. Will send out a draft V5 version for early review.

Regards
Anshuman

