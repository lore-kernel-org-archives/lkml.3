Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaIPVXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:23:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49644 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbaIPVXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:23:52 -0400
Message-ID: <5418AA54.9010704@zytor.com>
Date: Tue, 16 Sep 2014 14:23:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Tim Gardner <tim.gardner@canonical.com>
CC: Kamal Mostafa <kamal@canonical.com>, kernel-team@lists.ubuntu.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [3.13.y.z extended stable] Linux 3.13.11.7 stable review
References: <1410818997-9432-1-git-send-email-kamal@canonical.com> <20140916000309.GA8853@kroah.com> <54178FEB.3000606@canonical.com> <20140916012609.GB29475@kroah.com> <5418548B.9080609@canonical.com> <20140916181310.GB24080@kroah.com>
In-Reply-To: <20140916181310.GB24080@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 11:13 AM, Greg KH wrote:
> 
> By the "trailing digit", i.e. ".y", only.  It's just an aditional
> number, not a "vendor version mark", like most packaging systems all
> incorporate to show obviously that there is a difference from the
> "upstream" release here.
> 
>> I _want_ the consumer to be aware of where they have acquired their
>> kernel sources (as if the git URL is insufficient). Frankly, if the
>> version is an _enduring_ source of confusion, then perhaps the
>> consumer should seek other endeavors.
> 
> You are really trying to use the "if the user is so dumb to understand,
> they should just go away" argument here?  I value our users more than
> that, they are the only reason we will survive over time.  You will not
> succeed by going around calling them names.
> 

It is worth noting that we have a long-standing convention for these
sort of things.  It looks like x.y[.z]-XXn where XX is two or three
letters, e.g. 3.13.11-km7.

	-hpa


