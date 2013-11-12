Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab3KLViL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:38:11 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56995 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755541Ab3KLViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:38:04 -0500
X-Sasl-enc: S7Xt4p0YGjb//NxQaQP2fRFMLnH1pu3ZnPCgRWYOLRFB 1384292281
Message-ID: <52829FB8.6070404@iki.fi>
Date: Tue, 12 Nov 2013 23:38:00 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Simplify '--summary' output
References: <1384267334-18953-1-git-send-email-penberg@kernel.org> <20131112213334.GF25913@gmail.com> <52829F4F.6070800@gmail.com>
In-Reply-To: <52829F4F.6070800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 11:36 PM, David Ahern wrote:
> On 11/12/13, 2:33 PM, Ingo Molnar wrote:
>>> >  Summary of events:
>>> >
>>> >  dbus-daemon (555), 10 events, 0.0%, 0.000 msec
>>> >
>>> > msec/call
>>> >    syscall            calls      min      avg      max stddev
>>> >    --------------- -------- -------- -------- -------- ------
>>> >    sendmsg                2    0.002    0.005    0.008 55.00
>>> >    recvmsg                2    0.002    0.003    0.005 44.00
>>> >    epoll_wait             1    0.000    0.000    0.000 0.00
>> In what units is stddev? Percentage? If yes then it might be useful to
>> output it as %. [and probably to restrict precision to a single digit,
>> standard deviations are rarely more accurate than 0.1%.]
>>
>
> %. That was dropped in the recent output change.

Sorry about that. Why do we show them in percentages, btw? Standard 
deviation is usually represented in the same unit as the data to make it 
readable.

                         Pekka
