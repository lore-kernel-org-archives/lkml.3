Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaIPPRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:17:47 -0400
Received: from mail.tpi.com ([74.45.170.26]:37694 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbaIPPRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:17:33 -0400
Message-ID: <5418548B.9080609@canonical.com>
Date: Tue, 16 Sep 2014 09:17:31 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Kamal Mostafa <kamal@canonical.com>, kernel-team@lists.ubuntu.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [3.13.y.z extended stable] Linux 3.13.11.7 stable review
References: <1410818997-9432-1-git-send-email-kamal@canonical.com> <20140916000309.GA8853@kroah.com> <54178FEB.3000606@canonical.com> <20140916012609.GB29475@kroah.com>
In-Reply-To: <20140916012609.GB29475@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 07:26 PM, Greg KH wrote:
> On Mon, Sep 15, 2014 at 07:18:35PM -0600, Tim Gardner wrote:
>> On 09/15/2014 06:03 PM, Greg KH wrote:
>>> On Mon, Sep 15, 2014 at 03:06:50PM -0700, Kamal Mostafa wrote:
>>>> This is the start of the review cycle for the Linux 3.13.11.7 stable kernel.
>>>>
>>>> This version contains 187 new patches, summarized below.  The new patches are
>>>> posted as replies to this message and also available in this git branch:
>>>>
>>>> http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog
>>>>
>>>> git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review
>>>>
>>>> The review period for version 3.13.11.7 will be open for the next three days.
>>>> To report a problem, please reply to the relevant follow-up patch message.
>>>
>>> As I asked before, please change the name to not be x.y, it is confusing
>>> for lots of people.
>>>
>>> Use the "normal" way of naming kernel releases, pick a few character
>>> naming scheme please.
>>>
>>
>> I think what Kamal said is that he would consider your request. I,
>> however, don't think it wise to change version schemes mid-stream in an
>> established series.
> 
> Even if that "established series" is the thing that is causing
> complaints?
> 
>> Can you provide hard evidence that this version scheme is confusing lots
>> of people ? I'm only aware of one complaint voiced by Peter Anvin at the
>> kernel summit (http://lwn.net/Articles/608917/).
> 
> Peter's complaint is one that I know of that is in the public record.
> 
> So is mine.
> 
> How many others do you need?
> 

This is a seriously silly argument over an _opinion_ of what is
"confusing", and so far I am not feeling moved by the number of contrary
opinions.

Our version scheme makes sense from a Debian perspective in that it
indicates exactly when the Canonical branch was started. It also has the
advantage of being distinguishable from the kernel.org version. I _want_
the consumer to be aware of where they have acquired their kernel
sources (as if the git URL is insufficient). Frankly, if the version is
an _enduring_ source of confusion, then perhaps the consumer should seek
other endeavors.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
