Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaIDVX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:23:26 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54463 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbaIDVXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:23:25 -0400
Message-ID: <5408D84B.7040302@lwfinger.net>
Date: Thu, 04 Sep 2014 16:23:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andreea Bernat <bernat.ada@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Elena Oat <oat.elena@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] rtl8188eu: Replace rcu_dereference() with rcu_access_pointer()
References: <20140817114336.GA24984@ada>	<20140830204246.GA16563@kroah.com> <CALDM6bpomcGJk1Ut2hb8qO0gYeKkHruJZ0duBwAaonFf6HbZwA@mail.gmail.com>
In-Reply-To: <CALDM6bpomcGJk1Ut2hb8qO0gYeKkHruJZ0duBwAaonFf6HbZwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 03:58 PM, Andreea Bernat wrote:
> Hello,
>
> I cloned this:
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
>
> and after moved to staging-next branch, but in both cases, in
> those files I don't find any use of rcu_dereference() call (the call
> which I am looking for to modify).

The rcu_dereference() call in core/rtw_mlme.c is no longer there in mainline 
3.17, thus it was removed some time ago.

There is a similar reference in os_dep/recv_linux.c. Perhaps it should be removed.

This problem shows the importance of working with the latest pull of the staging 
repo when working with staging code. Even then patches may suffer mid-air 
collisions if multiple devs are working on a particular piece of code.

Larry


