Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbaDBDl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 23:41:58 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54662 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbaDBDl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 23:41:56 -0400
Message-ID: <533B86A5.90700@linux.vnet.ibm.com>
Date: Wed, 02 Apr 2014 09:10:21 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] powerpc, ptrace: Add few more ptrace request macros
References: <1396350893-4456-1-git-send-email-khandual@linux.vnet.ibm.com> <25834.1396399387@ale.ozlabs.ibm.com>
In-Reply-To: <25834.1396399387@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040203-2000-0000-0000-00001072E549
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 06:13 AM, Michael Neuling wrote:
> Anshuman Khandual <khandual@linux.vnet.ibm.com> wrote:
>> > This patch adds few more ptrace request macros expanding
>> > the existing capability. These ptrace requests macros can
>> > be classified into two categories.
> Why is this only an RFC?
> 

Looking for comments, suggestions, concerns from people. But looks
like its bit big a patch to review at once.

> Also, please share the test case that you wrote for this.

Will split the patch into multiple components, add the test case
and send out again.

