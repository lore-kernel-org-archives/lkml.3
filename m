Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbaD2Pss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:48:48 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:39068 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419AbaD2Psr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:48:47 -0400
X-Spam-Flag: NO
Message-ID: <535FC9D5.4040107@pavlinux.ru>
Date: Tue, 29 Apr 2014 19:48:37 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH RT 0/3] Linux 3.2.57-rt84-rc1
References: <20140427143925.177486597@goodmis.org>	<535D8180.1020607@pavlinux.ru> <20140428093956.78d0f3ea@gandalf.local.home>
In-Reply-To: <20140428093956.78d0f3ea@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

28.04.2014 17:39, Steven Rostedt пишет:
> On Mon, 28 Apr 2014 02:15:28 +0400
> Pavel Vasilyev <pavel@pavlinux.ru> wrote:
>
>> 27.04.2014 18:39, Steven Rostedt пишет:
>>> Dear RT Folks,
>>>
>>> This is the RT stable review cycle of patch 3.2.57-rt84-rc1.
>>>
>>> Please scream at me if I messed something up. Please test the patches too.
>>
>>
>> More than two years our thin clients (about 5000 machines, Intel Atom, x86_32)
>> work with RCU_BOOST.
>>
>> CONFIG_RCU_BOOST=y
>> CONFIG_RCU_BOOST_PRIO=80
>> CONFIG_RCU_BOOST_DELAY=400
>>
>
> Is this just a confirmation of having RCU_BOOST default y for
> PREEMPT_RT is a good thing?


Only 3.2-rt


-- 

                                                          Pavel.
