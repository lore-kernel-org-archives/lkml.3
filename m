Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab3HEVN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 17:13:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22025 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab3HEVNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 17:13:25 -0400
Message-ID: <52001564.1010800@oracle.com>
Date: Mon, 05 Aug 2013 17:13:08 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kent Overstreet <kent.overstreet@gmail.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        trinity@vger.kernel.org
Subject: Re: percpu: kernel BUG at mm/percpu.c:579!
References: <51FFBB7D.70608@oracle.com> <20130805145736.GB19631@mtj.dyndns.org> <20130805191517.GA9198@kmo-pixel>
In-Reply-To: <20130805191517.GA9198@kmo-pixel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 03:15 PM, Kent Overstreet wrote:
>>  From percpu_ref release path.  Kent?
>  From the backtrace I have no idea if this was from the aio code using it
> or the cgroup code - Sasha, any idea?
>
> AIO is probably more likely, I'm going to look to see if I can find
> anything...

I honestly don't know. It ran under trinity so I'm not sure what the exact
scenario is.

I can't seem to hit it again easily so far, it seems that many people merged their
work in the -next tree recently so I'm seeing multiple unrelated failures all over
the place, which makes reproducing this one harder.


Thanks,
Sasha


