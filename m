Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3HBTNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:13:19 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:43002 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab3HBTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:13:17 -0400
Message-ID: <51FC04C2.70100@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 14:13:06 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linux-mm <linux-mm@kvack.org>, isimatu.yasuaki@jp.fujitsu.com,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/8] Add all memory via sysfs probe interface at once
References: <51F01E06.6090800@linux.vnet.ibm.com> <51F01EFB.6070207@linux.vnet.ibm.com> <20130802023259.GC1680@concordia>
In-Reply-To: <20130802023259.GC1680@concordia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080219-5564-0000-0000-000009175597
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 09:32 PM, Michael Ellerman wrote:
> On Wed, Jul 24, 2013 at 01:37:47PM -0500, Nathan Fontenot wrote:
>> When doing memory hot add via the 'probe' interface in sysfs we do not
>> need to loop through and add memory one section at a time. I think this
>> was originally done for powerpc, but is not needed. This patch removes
>> the loop and just calls add_memory for all of the memory to be added.
> 
> Looks like memory hot add is supported on ia64, x86, sh, powerpc and
> s390. Have you tested on any?

I have tested on powerpc. I would love to say I tested on the other
platforms... but I haven't.  I should be able to get a x86 box to test
on but the other architectures may not be possible.

-Nathan

