Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3EHD2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 23:28:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:60039 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3EHD2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 23:28:10 -0400
X-Spam-Score: -100.8
Message-ID: <5189C617.5020508@asianux.com>
Date: Wed, 08 May 2013 11:27:19 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Li Zefan <lizefan@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Drivers: Misc: fix warnings, unsigned long will never
 < 0
References: <5160E37C.3020007@asianux.com> <5160E7EA.3050406@asianux.com> <5189B76C.9050606@asianux.com> <20130508023803.GB19842@kroah.com> <5189BCA1.1090105@huawei.com> <20130508025422.GA3888@kroah.com>
In-Reply-To: <20130508025422.GA3888@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 10:54, Greg KH wrote:
> On Wed, May 08, 2013 at 10:46:57AM +0800, Li Zefan wrote:
>> On 2013/5/8 10:38, Greg KH wrote:
>>> On Wed, May 08, 2013 at 10:24:44AM +0800, Chen Gang wrote:
>>>> Hello Maintainers:
>>>>
>>>> Please help check, when you have time.
>>>>
>>>> Thanks.
>>>>
>>>> On 2013年04月07日 11:28, Chen Gang wrote:
>>>
>>> <snip>
>>>
>>> You sent a cleanup patch in the middle of the merge window, when we
>>> can't take any patches at the moment due to other work, and expect a
>>> review in less than 24 hours?
>>>
>>
>> No, he sent the patch one month ago, so to be honest he's quite patient,
>> though he picked a wrong time to ping you. ;)
> 
> Obviously, I don't even know what month this is :)
> 

Next, I really need get rid of any Chinese characters in mail. :)


> Chen, very sorry about that.  I'll look into it next week, it's probably
> lost somewhere in my todo queue.
> 

Not mind, it is really only a cleanup patch, and also you are really
busy, so please look into it just when you have time.

And I should focus on continuing to find and make another patches and
should try to answer, analyse, and learn some a little deeper questions
(e.g. a question about get_tree() in kernel/audit_tree.c).


Thanks.

-- 
Chen Gang

Asianux Corporation
