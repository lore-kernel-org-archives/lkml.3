Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaDGBzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 21:55:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19835 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaDGBzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 21:55:43 -0400
Message-ID: <5342058E.4090500@oracle.com>
Date: Sun, 06 Apr 2014 21:55:26 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: linux-f2fs-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: f2fs: kernel BUG at fs/f2fs/segment.h:543
References: <53401D4A.1020203@oracle.com> <1396833642.12401.12.camel@kjgkr>
In-Reply-To: <1396833642.12401.12.camel@kjgkr>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2014 09:20 PM, Jaegeuk Kim wrote:
> Hi,
> 
> Thank you for the report.
> 
> If possible, could you share fsck.f2fs or dump.f2fs on the corrupted
> partition?
> 
> Otherwise, how about this?
> # fdisk /dev/sdx
>> > p

Hey Jaegeuk,

Unfortunately it was a temporary filesystem inside the fuzzer that has
gone away as soon as the kernel died, so I don't have access to it.


Thanks,
Sasha
