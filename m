Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbaIEDhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 23:37:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17950 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaIEDhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 23:37:32 -0400
Message-ID: <54092FE0.3030004@oracle.com>
Date: Thu, 04 Sep 2014 23:37:04 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, akpm@linuxfoundation.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: add support for gcc 5
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>	 <20140904212535.GA5059@drone.musicnaut.iki.fi>	 <1409870628.2310799.163815377.623F33D2@webmail.messagingengine.com> <1409874455.2770.26.camel@joe-AO725>
In-Reply-To: <1409874455.2770.26.camel@joe-AO725>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 07:47 PM, Joe Perches wrote:
> On Fri, 2014-09-05 at 00:43 +0200, Hannes Frederic Sowa wrote:
>> > Most statements are already depending on GCC_VERSION, maybe we can just
>> > unify all gcc specific headers to one, still trying to keep the file
>> > organized? ;)
> Maybe something like:
> 
> gnu development of gcc will be more frequent and the use of
> compiler-gcc<major>.h likely will not be convenient anymore.
> 
> Integrate the individual compiler-gcc<major>.h files into
> compiler-gcc.h.

Please no. We have a similar file we maintain in our team that's supposed to
do something very similar for kernel versions. It goes all the way back to
2.6.9 and it's a *horrible* mess.

This is how compiler-gcc.h will end up looking in a while.


Thanks,
Sasha
