Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3FECH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 22:07:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:35814 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3FECH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:07:57 -0400
Message-ID: <51AEA06A.7040206@windriver.com>
Date: Wed, 5 Jun 2013 10:20:26 +0800
From: Xufeng Zhang <xufeng.zhang@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Greg KH <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <nhorman@tuxdriver.com>,
        <vyasevich@gmail.com>, <davem@davemloft.net>
Subject: Re: [PATCH] sctp: set association state to established in dupcook_a
 handler
References: <1370245978-12884-1-git-send-email-xufeng.zhang@windriver.com>	 <20130603142811.GE7024@kroah.com> <51AD4A34.6050606@windriver.com> <1370391220.21654.73.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1370391220.21654.73.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 08:13 AM, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 10:00 +0800, Xufeng Zhang wrote:
>    
>> On 06/03/2013 10:28 PM, Greg KH wrote:
>>      
>>> On Mon, Jun 03, 2013 at 03:52:58PM +0800, Xufeng Zhang wrote:
>>>
>>>        
>>>> 3.4-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>>          
>>> Really?  What are you going to do with it if no one objects?
>>>
>>>        
>> Sorry, I don't have any experience with stable patch and I consult
>> stable_kernel_rules.txt, there are not much special rules and here I just
>> want to specify the kernel version I wish it to be applied to.
>>
>>      
>>> I know I'm sure not going to do anything with it...
>>>
>>> (hint, this isn't how you ask for networking stable patches to be
>>> applied.)
>>>
>>>        
>> Ok, thanks for your hint, I'll resend the patch.
>>      
> The heading you used should only be used by a stable branch maintainer
> sending out a series of patches they've already accepted, prior to
> making a new release.  If you want a fix to be added to be applied to
> one or more stable branches, you should write in the form of a request.
> And if you're just not sure, then you should write in the form of a
> question.
>
> Networking is a special case in that the subsystem maintainer, David
> Miller, generally collects together and backports fixes for all the
> official 3.x branches.  So you should send your request to him (but do
> cc the stable and subsystem lists as well).
>    
Thank you, Ben!
Now it's more clear.


Thanks,
Xufeng
> Ben.
>
>    

