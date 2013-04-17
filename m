Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3DQEBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 00:01:06 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36073 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3DQEBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 00:01:04 -0400
Message-ID: <516E1E6C.2040106@linux.vnet.ibm.com>
Date: Wed, 17 Apr 2013 09:30:44 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org
Subject: Re: [PATCH V2 2/5] powerpc, perf: Add basic assembly code to read
 BHRB entries on POWER8
References: <1366127650-1952-1-git-send-email-khandual@linux.vnet.ibm.com> <1366127650-1952-3-git-send-email-khandual@linux.vnet.ibm.com> <AAEA07FE-7530-46D3-B2FC-B3FD8EC2C6E2@kernel.crashing.org>
In-Reply-To: <AAEA07FE-7530-46D3-B2FC-B3FD8EC2C6E2@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041703-8256-0000-0000-0000071A082A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 10:53 PM, Segher Boessenkool wrote:
>> +/* r3 = n  (where n = [0-1023])
>> + * The maximum number of BHRB entries supported with PPC_MFBHRBE
>> instruction
>> + * is 1024. We have limited number of table entries here as POWER8
>> implements
>> + * 32 BHRB entries.
>> + */
>> +
>> +/* .global read_bhrb */
>> +_GLOBAL(read_bhrb)
>> +    cmpldi    r3,1023
> 
> This should be 31, since that is the last entry in the table below.

Hey Segher,

Would fix this in the next version. Thanks for pointing it out.

Regards
Anshuman

