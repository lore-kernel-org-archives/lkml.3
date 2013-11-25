Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3KYN6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:58:09 -0500
Received: from static-209-166-131-148.expedient.com ([209.166.131.148]:57288
	"EHLO natasha.panasas.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756634Ab3KYN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:58:00 -0500
Message-ID: <52935754.1070208@panasas.com>
Date: Mon, 25 Nov 2013 15:57:40 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: LKP <fnstml-lkp@cn.fujitsu.com>, Fengguang Wu <fengguang.wu@intel.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 0 PID: 1 at init/main.c:711 do_one_initcall()
References: <20131122060223.GP9991@yliu-dev.sh.intel.com> <529329DE.4010709@panasas.com> <20131125132542.GX9991@yliu-dev.sh.intel.com>
In-Reply-To: <20131125132542.GX9991@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 03:25 PM, Yuanhan Liu wrote:
> 
> Hi Boaz,
> 
> We are running an 0day kernel testing system. We will test all developers'
> tree we tracked in our system automatically. And obviously, linux-open-osd
> is in that list.
> 
> This system can't tell whether a branch is experimental unless
> - You put one extra line of "Dont-Auto-Build" to the head commit log.
> 
> - the branch name contains "experimental", say exofs_ioctl-experimental
> 
> If both items aren't convenient to you, you can ask us to remove your
> tree from that list. Then you will never get report like this from us.
> However, you may lose a chance to find build, boot and performance bug
> automatically for you ;)
> 
> 	--yliu
> 


Ha OK very cool. I will remember to put -experimental on the branch name
this is fine I will do it ASAP.

Thanks so much. Do you have some web based info on the build system?
Do you have a place I can see test results and tests summery?

Cheers
Boaz

