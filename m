Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbbAMHuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:50:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:42209 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbAMHux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:50:53 -0500
Message-ID: <54B4CE3E.8020009@windriver.com>
Date: Tue, 13 Jan 2015 15:50:22 +0800
From: Ying Xue <ying.xue@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>
CC: <linux-kernel@vger.kernel.org>, <lkp@01.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: Fwd: [rhashtable] WARNING: CPU: 0 PID: 10 at kernel/locking/mutex.c:570
 mutex_lock_nested()
References: <20150110194803.GA9033@wfg-t540p.sh.intel.com> <54B3259B.7080601@windriver.com> <20150112124216.GA26570@casper.infradead.org>
In-Reply-To: <20150112124216.GA26570@casper.infradead.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.163.180]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 08:42 PM, Thomas Graf wrote:
> On 01/12/15 at 09:38am, Ying Xue wrote:
>> Hi Thomas,
>>
>> I am really unable to see where is wrong leading to below warning
>> complaints. Can you please help me check it?
> 
> Not sure yet. It's not your patch that introduced the issue though.
> It merely exposed the affected code path.
>
> Just wondering, did you test with CONFIG_DEBUG_MUTEXES enabled?
> 
> 

After I enable above option, I don't find similar complaints during my
testing.

Regards,
Ying

