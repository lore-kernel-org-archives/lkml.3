Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbaBRMS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:18:26 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43865 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaBRMSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:18:24 -0500
Message-ID: <53034F8A.107@gmail.com>
Date: Tue, 18 Feb 2014 13:18:18 +0100
From: Bastien Traverse <bastien.traverse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Peter Wu <lekensteyn@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Francis Moreau <francis.moro@gmail.com>
Subject: Re: 3.12: ethernet controller missing after resuming from suspend
 to RAM
References: <52F2CC7B.80406@gmail.com> <1835578.EmLUpvTMQe@vostro.rjw.lan> <52FB264D.30809@gmail.com> <1717405.VfecqV3UgO@vostro.rjw.lan>
In-Reply-To: <1717405.VfecqV3UgO@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mer. 12 févr. 2014 15:04:28 CET, Rafael J. Wysocki a écrit :
>>> Mika, I'll add a changelog to your patch and queue it up as a fix for 3.14.
>>>
>>
>> Thanks guys for solving this issue !
>>
>> Rafael, could this be submitted to stable trees (at least 3.12, 3.13) as
>> well ?
>
> Yes, I have marked it for stable.

Thanks a lot for dealing with this!
Cheers

