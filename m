Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3FGJJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:09:42 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:38685 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3FGJJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:09:37 -0400
Message-ID: <51B1A33C.1020708@huawei.com>
Date: Fri, 7 Jun 2013 17:09:16 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@vger.kernel.org>,
        <lwn@lwn.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.0.80
References: <20130524182347.GA3110@kroah.com>
In-Reply-To: <20130524182347.GA3110@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/25 2:23, Greg KH wrote:
> I'm announcing the release of the 3.0.80 kernel.
> 
> All users of the 3.0 kernel series must upgrade.
> 
> The updated 3.0.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
> and can be browsed at the normal kernel.org git web browser:
> 	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
> 
> ------------
> 
>  Makefile                              |    2 +-
>  drivers/hwmon/abituguru.c             |   16 ++++++++++------
>  drivers/media/dvb/mantis/mantis_dvb.c |    6 ++++--
>  fs/btrfs/ioctl.c                      |   10 +++++-----
>  4 files changed, 20 insertions(+), 14 deletions(-)
> 

3.0.80 failed to boot, and looks like the culprit is blkcg, so I disabled
CONFIG_CGROUP and it boot successfully.

I haven't tried 3.0.81, as it's not released yet.

