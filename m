Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaJTSpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:45:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50361 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaJTSph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:45:37 -0400
Message-ID: <5445587B.8090203@arm.com>
Date: Mon, 20 Oct 2014 19:46:19 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: [PATCH v5 00/11] drivers: cacheinfo support
References: <1412084912-2767-1-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1412084912-2767-1-git-send-email-sudeep.holla@arm.com>
X-OriginalArrivalTime: 20 Oct 2014 18:45:35.0439 (UTC) FILETIME=[08D3EDF0:01CFEC96]
X-MC-Unique: 114102019453503801
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 30/09/14 14:48, Sudeep Holla wrote:
> This series adds a generic cacheinfo support similar to topology. The
> implementation is based on x86 cacheinfo support. Currently x86, powerpc,
> ia64 and s390 have their own implementations. While adding similar support
> to ARM and ARM64, here is the attempt to make it generic quite similar to
> topology info support. It also adds the missing ABI documentation for
> the cacheinfo sysfs which is already being used.
>
> It moves all the existing different implementations on x86, ia64, powerpc
> and s390 to use the generic cacheinfo infrastructure introduced here.
> These changes on non-ARM platforms are only compile tested and tested on x86.
>
> This series also adds support for ARM and ARM64 architectures based on
> the generic support.
>
> The code can be fetched from:
>   git://linux-arm.org/linux-skn cacheinfo
>

I am hoping to target this for v3.19 if possible, it would be good if
you can review and provide feedback.

Regards,
Sudeep

