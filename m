Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaHRPns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:43:48 -0400
Received: from sv1-2.x14.eu ([144.76.176.218]:45563 "EHLO sv1-2.x14.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaHRPnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:43:47 -0400
Message-ID: <53F21F2C.9010905@vipserv.org>
Date: Mon, 18 Aug 2014 17:43:40 +0200
From: Krzysztof Majzerowicz-Jaszcz <cristos@vipserv.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Alexander Duyck <alexander.h.duyck@intel.com>, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: ethernet: intel: e1000: e1000_ethtool.c
 coding style fixes
References: <1408180328-4827-1-git-send-email-cristos@vipserv.org>	 <1408214489.2683.87.camel@joe-AO725> <53F21BEC.2070204@intel.com>	 <1408375914.2741.1.camel@joe-AO725> <53F21D6F.7000306@vipserv.org> <1408376459.2741.4.camel@joe-AO725>
In-Reply-To: <1408376459.2741.4.camel@joe-AO725>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Authenticated-User: cristos@vipserv.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/08/14 17:40, Joe Perches wrote:
> On Mon, 2014-08-18 at 17:36 +0200, Krzysztof Majzerowicz-Jaszcz wrote:
>> On 18/08/14 17:31, Joe Perches wrote:
>>> On Mon, 2014-08-18 at 08:29 -0700, Alexander Duyck wrote:
>>>> Doing any kind of pointer math on a void pointer is generally unsafe as
>>>> it is an incomplete type.  The only reason why it works in GCC is
>>>> because GCC has a nonstandard extension that makes it report as having a
>>>> size of 1.
>>>
>>> I know.  It's used in quite a few places in kernel code
>>> so I believe it's now a base assumption for the kernel.
>>>
>> Ok, so what do you suggest - void* or char* here ?
> 
> Do what you (or Alex) think is best.
> 
> My main point was trying to make the code a bit
> clearer.a
> 
OK, thank you for your suggestions. I'll send an updated version of this patch soon.
