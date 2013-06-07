Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab3FGJVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:21:40 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:7298 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab3FGJVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:21:37 -0400
Message-ID: <51B1A5DF.7030703@huawei.com>
Date: Fri, 7 Jun 2013 17:20:31 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        <stable@vger.kernel.org>, <lwn@lwn.net>
Subject: Re: Linux 3.2.46
References: <1370005571.3469.505.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1370005571.3469.505.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/31 21:06, Ben Hutchings wrote:
> I'm announcing the release of the 3.2.46 kernel.
> 
> All users of the 3.2 kernel series should upgrade.
> 
> The updated 3.2.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.2.y
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git
> 

I guess you'll get compile error if you enable ftrace but disable CONFIG_DYNAMIC_FTRACE,
and you need to backport 7f49ef69db6bbf756c0abca7e9b65b32e999eec8.

