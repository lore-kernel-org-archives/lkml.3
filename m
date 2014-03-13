Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaCMJvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:51:36 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:56778 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbaCMJvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:51:35 -0400
Message-ID: <53217FA1.4020903@gmail.com>
Date: Thu, 13 Mar 2014 09:51:29 +0000
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ARM: add initial support for the Marvell BG2-Q DMP
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com> <20140312113523.GL13905@piout.net>
In-Reply-To: <20140312113523.GL13905@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 11:35 AM, Alexandre Belloni wrote:
> On 12/03/2014 at 12:06:02 +0100, Antoine Ténart wrote :
>> This serie adds the initial support for the Marvell BG2-Q DMP (part of the
>> Berlin family). SoC has nodes for cpu, l2 cache controller, interrupt
>> controllers, local timer, apb timers and uarts for now.
>>
>> Homepage: http://www.marvell.com/digital-entertainment/armada-1500-pro/
>>
>
> I would move that description to the commit logs. Else one would have to
> lookup the mailing list archive to read it.

Antoine,

thanks for posting this. I also prefer each patch to have a commit log
no matter how obvious the contents may be. Please have a simple commit
log for each of the single patches.

You can leave out the link to marvell.com in the commit log as you
update Marvell SoC documentation.

TBH, I haven't set up any mach-berlin branches, yet. Also it is very
late in the cycle. I'll setup proper branches and also a -next branch
for next release, maybe we can take your DT patches directly through
arm-soc this time. Otherwise, we'll have to postpone them for v3.16.

I have some comments on the single patches and will reply there.

Sebastian

