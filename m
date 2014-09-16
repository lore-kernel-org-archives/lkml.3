Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaIPBvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:51:50 -0400
Received: from mail.tpi.com ([74.45.170.26]:33498 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbaIPBvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:51:47 -0400
X-Greylist: delayed 1990 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 21:51:47 EDT
Message-ID: <54178FEB.3000606@canonical.com>
Date: Mon, 15 Sep 2014 19:18:35 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Kamal Mostafa <kamal@canonical.com>, kernel-team@lists.ubuntu.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [3.13.y.z extended stable] Linux 3.13.11.7 stable review
References: <1410818997-9432-1-git-send-email-kamal@canonical.com> <20140916000309.GA8853@kroah.com>
In-Reply-To: <20140916000309.GA8853@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 06:03 PM, Greg KH wrote:
> On Mon, Sep 15, 2014 at 03:06:50PM -0700, Kamal Mostafa wrote:
>> This is the start of the review cycle for the Linux 3.13.11.7 stable kernel.
>>
>> This version contains 187 new patches, summarized below.  The new patches are
>> posted as replies to this message and also available in this git branch:
>>
>> http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog
>>
>> git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review
>>
>> The review period for version 3.13.11.7 will be open for the next three days.
>> To report a problem, please reply to the relevant follow-up patch message.
> 
> As I asked before, please change the name to not be x.y, it is confusing
> for lots of people.
> 
> Use the "normal" way of naming kernel releases, pick a few character
> naming scheme please.
> 

I think what Kamal said is that he would consider your request. I,
however, don't think it wise to change version schemes mid-stream in an
established series.

Can you provide hard evidence that this version scheme is confusing lots
of people ? I'm only aware of one complaint voiced by Peter Anvin at the
kernel summit (http://lwn.net/Articles/608917/).

rtg
-- 
Tim Gardner tim.gardner@canonical.com
