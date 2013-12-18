Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3LRMve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:51:34 -0500
Received: from mx2.comprocs.com ([12.186.155.30]:55083 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753313Ab3LRMvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:51:33 -0500
X-BYPSHEADER: 22658392
X-SMScore: -1050
Message-ID: <52B19A54.6070409@compro.net>
Date: Wed, 18 Dec 2013 07:51:32 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: question about cpu_active_mask
References: <52B0BBBD.3000704@compro.net> <294848935.31685.1387339274917.JavaMail.root@mx2.compro.net>
In-Reply-To: <294848935.31685.1387339274917.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 11:00 PM, Mike Galbraith wrote:
> On Tue, 2013-12-17 at 16:01 -0500, Mark Hounschell wrote:
>> I hope it is OK to ask a newbie question here. I'm trying to better
>> understand the boot process. I can't seem to find where in the kernel
>> sources the cpu_active_mask (defined in include/linux/cpumask.h) gets
>> populated. I can see that it does get populated as it brings cpus online
>> but it is not obvious to me where. I'm using a 32 bit 3.4.x flavor kernel.
>
> Try git grep set_cpu_active.
>

Got it. Thanks for that.

Regards
Mark
