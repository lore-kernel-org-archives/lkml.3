Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab3ANOIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:08:04 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60222 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab3ANOIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:08:02 -0500
Message-ID: <50F41119.3000608@gmail.com>
Date: Mon, 14 Jan 2013 22:07:21 +0800
From: Bin Wang <wbin00@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Cong Ding <dinggnu@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH RFC -next] Fix the trailing blank space issue
References: <1354784936-5647-1-git-send-email-wbin00@gmail.com> <20121206154219.GA24788@gmail.com> <20121206160606.GA15256@kroah.com> <20121206163138.GC2510@gmail.com> <20121206165958.GA9301@kroah.com>
In-Reply-To: <20121206165958.GA9301@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late response.

It is not a big deal about the code formate. It just makes me 
uncomfortable since my editor has a highlight for the trailing space. 
The similar things are the two-space between words of document and so on.

It's surely better to formate the code. So I submit a patch while I just 
read and find these little things . I'm not sure if it is a waste of 
time for the maintainers.

On 12/07/2012 12:59 AM, Greg Kroah-Hartman wrote:
> On Thu, Dec 06, 2012 at 04:31:39PM +0000, Cong Ding wrote:
>> On Thu, Dec 06, 2012 at 08:06:06AM -0800, Greg Kroah-Hartman wrote:
>>> On Thu, Dec 06, 2012 at 03:42:20PM +0000, Cong Ding wrote:
>>>> On Thu, Dec 06, 2012 at 05:08:56PM +0800, Bin Wang wrote:
>>>>> This patch removes the trailing white space in fs/sysfs/mount.c.
>>>>>
>>>>> Signed-off-by: Bin Wang <wbin00@gmail.com>
>>>>> ---
>>>>>   fs/sysfs/mount.c | 2 +-
>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>> Hi Greg,
>>>>
>>>> I am not sure it is really necessary to remove all the trailing blank spaces
>>>> in the project. I have done a try by this shell command
>>>> $ find . -iname '*.[ch]' | xargs sed 's/\s\+$//g' -i
>>>> and find there are 2812 files/31712 lines with this issue.
>>> That's very true, why would you want to do this?
>>>
>>> This comes up every 6 months or so on the linux-kernel mailing list,
>>> please see the archives for previous responses to the topic.
>>>
>>> If you want, just slowly send patches to the different subsystem
>>> maintainers, to clean the issue up.
>> sorry for forgetting press "reply all" in the former email...
>>
>> Sending them slowly to different subsystem maintainers is a very bad idea,
>> because it wastes lots of time for both me and them. But the current situation
>> is that there are some people send this kind of patches in random time which
>> also is a kind of wasting their time.
>>
>> I think we'd better to find a solution, not only for the blank space issue,
>> but also all the coding style issues able to be fixed by scripts.
>>
>> I would suggest to write a series of scripts. And then announce a date
>> (preferably some holiday like Xmas) to run these scripts. The announce is to
>> avoid conflicts with other developers. It will save both developers' and
>> subsystem maintains' time, do you agree?
> No I do not, it's not a big issue at all.  As I said, look in the
> archives, this comes up every six months or so.
>
> greg k-h

