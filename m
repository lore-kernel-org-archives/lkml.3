Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976Ab3IGGXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 02:23:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59382 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3IGGXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 02:23:43 -0400
Message-ID: <522AC66A.1000605@gmail.com>
Date: Sat, 07 Sep 2013 08:23:38 +0200
From: Christian Hoffmann <chrmhoffmann@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: jean-philippe francois <jp.francois@cynove.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        paulmck@linux.vnet.ibm.com
Subject: Re: omap: panda rcu stall on 3.10.1
References: <521DA180.9010306@gmail.com> <52203B54.70902@gmail.com> <CAGGh5h3AxogEURrQFd==zhGWpVF7eRaZPNo_Y1peC0TwS673Tw@mail.gmail.com>
In-Reply-To: <CAGGh5h3AxogEURrQFd==zhGWpVF7eRaZPNo_Y1peC0TwS673Tw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 10:10 AM, jean-philippe francois wrote:
> 2013/8/30 Christian Hoffmann <chrmhoffmann@gmail.com>:
>>
>>> This also went to: linaro-kernel@lists.linaro.org
>>
>> Hi,
>>
>> current linaro kernel on 13.07 (3.10.1.0-1-linaro-omap) shows stack below.
>> System is generally quite unstable. Light usage (postfix+dovecot...)
>>
>> Full dmesg here:
>> https://dl.dropboxusercontent.com/u/21820416/rcu.stall.panda
>>
> Hi,
>
> Does it happen when run with nohlt in the kernel command line ?

Hi,

the panda is much more stable (up now for 2 or three days) with nohlt. 
No sign of stack traces or RCU stalls.

Thank you.
Chris
