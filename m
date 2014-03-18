Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaCRHH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 03:07:59 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43467 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaCRHH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 03:07:57 -0400
Message-ID: <5327F218.1000506@linux.vnet.ibm.com>
Date: Tue, 18 Mar 2014 12:43:28 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Madper Xie <cxie@redhat.com>
CC: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, rientjes@google.com,
        Linus <torvalds@linux-foundation.org>, nacc@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 ] mm readahead: Fix readahead fail for memoryless cpu
 and limit readahead pages
References: <1392708338-19685-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140218094920.GB29660@quack.suse.cz> <53034C66.90707@linux.vnet.ibm.com> <871ty1zig4.fsf@redhat.com>
In-Reply-To: <871ty1zig4.fsf@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031807-3568-0000-0000-0000051D7C5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 07:37 AM, Madper Xie wrote:
>
> Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> writes:
>
>> On 02/18/2014 03:19 PM, Jan Kara wrote:
>>> On Tue 18-02-14 12:55:38, Raghavendra K T wrote:
> Hi. Just a concern. Will the performance reduce on some special storage
> backend? E.g. tape.
> The existent applications may using readahead for userspace I/O schedule
> to decrease seeking time.

I have not tested the patch on such systems yet unfortunately :(.
Sequential read with huge file has not suffered on disk based system,
but I think, I should be honest enough not to guess the effect on tape.

