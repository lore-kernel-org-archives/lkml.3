Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaIESVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:21:45 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65185 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaIESVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140904213821.GB356@kroah.com>
References: <20140817114336.GA24984@ada>
	<20140830204246.GA16563@kroah.com>
	<CALDM6bpomcGJk1Ut2hb8qO0gYeKkHruJZ0duBwAaonFf6HbZwA@mail.gmail.com>
	<20140904213821.GB356@kroah.com>
Date: Fri, 5 Sep 2014 21:21:42 +0300
Message-ID: <CALDM6bpwtfdnhjdsSMz_yq9kqk-BtVRJEVnPzzWaciXXBTh8_w@mail.gmail.com>
Subject: Re: [PATCH] rtl8188eu: Replace rcu_dereference() with rcu_access_pointer()
From: Andreea Bernat <bernat.ada@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Larry.Finger@lwfinger.net, Elena Oat <oat.elena@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-05 0:38 GMT+03:00 Greg KH <gregkh@linuxfoundation.org>:
> On Thu, Sep 04, 2014 at 11:58:36PM +0300, Andreea Bernat wrote:
>> Hello,
>>
>> I cloned this:
>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
>>
>> and after moved to staging-next branch, but in both cases, in
>> those files I don't find any use of rcu_dereference() call (the call
>> which I am looking for to modify).
>
> Then there's nothing left to be done here, right?  :)

Yes :-)

Thank you,
Andreea

>
> thanks,
>
> greg k-h
