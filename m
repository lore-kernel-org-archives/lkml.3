Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbaGCSx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:53:59 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53513 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaGCSx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:53:57 -0400
Message-ID: <53B5A5FE.2080500@linux.vnet.ibm.com>
Date: Fri, 04 Jul 2014 00:20:38 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm readahead: Fix sys_readahead breakage by reverting
 2MB limit (bug 79111)
References: <1404392547-11648-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <CA+55aFxOTqUAqEF7+83s890Q18qCHSQqDOxWqWHNjG_25hVhXg@mail.gmail.com> <53B59CB5.9060004@linux.vnet.ibm.com> <CA+55aFyRgYW6Y8paYKGfqE205enhiPsZ1C8wrKpFavVXq7ZAtA@mail.gmail.com> <CA+55aFwwSCrH5QDvrzzyHhRU5R849Mo8A3NdRMwm9OTeWH9diQ@mail.gmail.com> <53B5A343.4090402@linux.vnet.ibm.com>
In-Reply-To: <53B5A343.4090402@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070318-3568-0000-0000-000005CB4784
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 12:08 AM, Raghavendra K T wrote:
> On 07/03/2014 11:59 PM, Linus Torvalds wrote:
>> On Thu, Jul 3, 2014 at 11:22 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
[...]
t.
>>
>> I do *not* think we should bow down to insane man-pages that have
>> always been wrong, though, and I don't think we should increase it to
>> "let's just read-ahead a whole ISO image" kind of sizes..
>
> Okay, how about something like 256MB? I would be happy to send a patch
> for that change.

Sorry I was too fast. I think some thing like 16MB? I 'll send patch
with that (unless you different size in mind).

