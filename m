Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3JYDKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 23:10:24 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:33632 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab3JYDKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 23:10:23 -0400
MIME-Version: 1.0
In-Reply-To: <20131023105931.GG1275@quack.suse.cz>
References: <CAK2Ky6xH9rvmpqQ31bi1QrC=dvt9T_8+ELHUZf_MFZccV6MiAw@mail.gmail.com>
	<20131023105931.GG1275@quack.suse.cz>
Date: Fri, 25 Oct 2013 11:10:22 +0800
Message-ID: <CAK2Ky6xjz5htYdYp9rpfWt1fyK+3oc+i1nR9GWh_hyULpZ=QMg@mail.gmail.com>
Subject: Re: A thought about IO scheduler in linux kernel for SSD
From: =?GB2312?B?uqvA2g==?= <bonben1989@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/23 Jan Kara <jack@suse.cz>:
> On Wed 23-10-13 08:47:44, º«ÀÚ wrote:
>> Nowadays,the IO schedulers in linux kernel have four types:
>>
>> deadline,noop,Anticiptory and CFQ.CFQ is the default scheduler.But CFQ is
>> not a good scheduler for SSD,dealine may be a good choice.
>
>   That doesn't make much sense to me. If there are two bios in flight for
> some sector, results are undefined. Thus we usually avoid such situation
> (usually we want to have defined contents of the disk :). The exclusion is
> usually achieved at higher level using page locking etc. So adding code
> speeding up such requests doesn't seem worth it.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

Do you mean that the probability of two bios have the same start
sector in request list at this level is very low??Discuss with you
is a kind of enjoyment.
