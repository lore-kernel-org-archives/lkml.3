Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab3KMG6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:58:08 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40937 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab3KMG56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:57:58 -0500
X-Sasl-enc: H44lkWRA6jQ2YIPle0BECmDAbu2hi3umIPR78UqmlQy9 1384325877
Message-ID: <528322F3.5050008@iki.fi>
Date: Wed, 13 Nov 2013 08:57:55 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Simplify '--summary' output
References: <1384267334-18953-1-git-send-email-penberg@kernel.org> <20131112213334.GF25913@gmail.com> <52829F4F.6070800@gmail.com> <20131112214045.GA29680@gmail.com>
In-Reply-To: <20131112214045.GA29680@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 11:40 PM, Ingo Molnar wrote:
> So if you prefer unit-less lines that's defensible, perhaps output the
> unit somewhere else:
>
>      syscall            calls     min      avg      max  stddev
>                                 (msec)   (msec)   (msec)    (%)
>      --------------- -------- -------- -------- -------- ------
>      sendmsg                2    0.002    0.005    0.008  55.00
>      recvmsg                2    0.002    0.003    0.005  44.00
>      epoll_wait             1    0.000    0.000    0.000   0.00
>
> or so?

Looks good.  I'll make a patch later today unless someone else beats me 
to it.

                         Pekka
