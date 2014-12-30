Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaL3EDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 23:03:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31143 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaL3EDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 23:03:12 -0500
Message-ID: <54A223F0.1000807@oracle.com>
Date: Mon, 29 Dec 2014 22:02:56 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: tytso@mit.edu, nick <xerofoify@gmail.com>,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Remove TO DO in jfs_xtree.c
References: <549F55AC.9040308@gmail.com> <54A1D211.4080609@oracle.com> <20141230034807.GA12551@thunk.org>
In-Reply-To: <20141230034807.GA12551@thunk.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 09:48 PM, tytso@mit.edu wrote:
> On Mon, Dec 29, 2014 at 04:13:37PM -0600, Dave Kleikamp wrote:
>> On 12/27/2014 06:58 PM, nick wrote:
>>> Greetings Dave,
>>> I am wondering why there is a TO DO above this code:
>>>         * ToDo:  tlocks should be on doubly-linked list, so we can
>>>         * quickly remove it and add it to the end.
>>
>> I'm sure the idea was to avoid the for loop needed to find the previous
>> entry in the linked list. A doubly-linked list makes it much simpler to
>> remove an item from an arbitrary position in the list.
> 
> Hi Dave,
> 
> Just in case you weren't aware, Nick has been banned from the LKML
> list for being a troll.

Thanks, Ted. Now I remember some earlier threads. Forgot it was the same
person. Just figured him for a novice looking for something to contribute.

Thanks,
Shaggy
