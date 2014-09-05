Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbaIEPFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:05:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47840 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117AbaIEPFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:05:04 -0400
Message-ID: <5409D0EA.8000203@zytor.com>
Date: Fri, 05 Sep 2014 08:04:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard.weinberger@gmail.com>
CC: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH] kernel: add support for gcc 5
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>	<20140904141215.9e6125150824d0768aedbfcb@linux-foundation.org>	<CAFLxGvx0Os=qJP8XSpCvj17SNNk6YA1bNZoQsVO3CksgfFbxfQ@mail.gmail.com> <20140904142529.860f4dc4514def7fb7a9d365@linux-foundation.org>
In-Reply-To: <20140904142529.860f4dc4514def7fb7a9d365@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 02:25 PM, Andrew Morton wrote:
>>
>> CC'ing Hannes, he sent a much simpler gcc5 patch a few days ago.
>> https://lkml.org/lkml/2014/8/26/710
> 
> That approach won't last for long - as soon as we add some
> gcc5-specific thing, we'll need a new file.
> 
> Let history be a guide:
> 
> diff -u include/linux/compiler-gcc3.h include/linux/compiler-gcc4.h

It seems much saner to do that branching when we actually need to.  In
the meantime I suspect that a handful of redefinitions would actually be
cleaner.

	-hpa


