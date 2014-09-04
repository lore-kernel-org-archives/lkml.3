Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbaIDVc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:32:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27777 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbaIDVc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:32:26 -0400
Message-ID: <5408DA58.7000901@oracle.com>
Date: Thu, 04 Sep 2014 17:32:08 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: akpm@linuxfoundation.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: add support for gcc 5
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com> <20140904212535.GA5059@drone.musicnaut.iki.fi>
In-Reply-To: <20140904212535.GA5059@drone.musicnaut.iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 05:25 PM, Aaro Koskinen wrote:
> On Thu, Sep 04, 2014 at 11:37:19AM -0400, Sasha Levin wrote:
>> We're missing include/linux/compiler-gcc5.h which is required now
>> because gcc branched off to v5 in trunk.
>>
>> Just copy the relevant bits out of include/linux/compiler-gcc4.h,
>> no new code is added as of now.
>>
>> This fixes a build error when using gcc 5.
> 
> With the new GCC version numbering scheme, does this mean there will
> be a new such file to be added every year? Maybe this could be handled
> some other way?

One big file would be a huge mess.

I think that if it starts getting out of hand we can move them into
their own folder, something like:

	include/linux/compiler/gcc/gccX.h


Thanks,
Sasha
