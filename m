Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3EHCrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:47:12 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:46781 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3EHCrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:47:11 -0400
Message-ID: <5189BCA1.1090105@huawei.com>
Date: Wed, 8 May 2013 10:46:57 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Chen Gang <gang.chen@asianux.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Drivers: Misc: fix warnings, unsigned long will never
 < 0
References: <5160E37C.3020007@asianux.com> <5160E7EA.3050406@asianux.com> <5189B76C.9050606@asianux.com> <20130508023803.GB19842@kroah.com>
In-Reply-To: <20130508023803.GB19842@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/8 10:38, Greg KH wrote:
> On Wed, May 08, 2013 at 10:24:44AM +0800, Chen Gang wrote:
>> Hello Maintainers:
>>
>> Please help check, when you have time.
>>
>> Thanks.
>>
>> On 2013年04月07日 11:28, Chen Gang wrote:
> 
> <snip>
> 
> You sent a cleanup patch in the middle of the merge window, when we
> can't take any patches at the moment due to other work, and expect a
> review in less than 24 hours?
> 

No, he sent the patch one month ago, so to be honest he's quite patient,
though he picked a wrong time to ping you. ;)

> Please be realistic, I'll get to this eventually (i.e. next week at the
> earliest.)
> 
> Patience is a virtue.
> 

