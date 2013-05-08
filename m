Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3EHCua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:50:30 -0400
Received: from intranet.asianux.com ([58.214.24.6]:16202 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3EHCu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:50:29 -0400
X-Spam-Score: -100.8
Message-ID: <5189BD43.8060100@asianux.com>
Date: Wed, 08 May 2013 10:49:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Drivers: Misc: fix warnings, unsigned long will never
 < 0
References: <5160E37C.3020007@asianux.com> <5160E7EA.3050406@asianux.com> <5189B76C.9050606@asianux.com> <20130508023803.GB19842@kroah.com> <5189BCA1.1090105@huawei.com>
In-Reply-To: <5189BCA1.1090105@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年05月08日 10:46, Li Zefan wrote:
> On 2013/5/8 10:38, Greg KH wrote:
>> > On Wed, May 08, 2013 at 10:24:44AM +0800, Chen Gang wrote:
>>> >> Hello Maintainers:
>>> >>
>>> >> Please help check, when you have time.
>>> >>
>>> >> Thanks.
>>> >>
>>> >> On 2013年04月07日 11:28, Chen Gang wrote:
>> > 
>> > <snip>
>> > 
>> > You sent a cleanup patch in the middle of the merge window, when we
>> > can't take any patches at the moment due to other work, and expect a
>> > review in less than 24 hours?
>> > 
> No, he sent the patch one month ago, so to be honest he's quite patient,
> though he picked a wrong time to ping you. ;)
> 

That seems I need get 'rid' of all Chinese characters in mail, which can
lead another members misreading. ;)

Thanks.

-- 
Chen Gang

Asianux Corporation
