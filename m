Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868Ab3ICJ7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:59:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:59100 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3ICJ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:59:23 -0400
X-Spam-Score: -100.9
Message-ID: <5225B2BA.5080001@asianux.com>
Date: Tue, 03 Sep 2013 17:58:18 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Li Zefan <lizefan@huawei.com>, Joe Perches <joe@perches.com>,
        Jens Axboe <axboe@kernel.dk>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] block/ioctl.c: let code match 'kernel code style'
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com> <5220254E.3050704@roeck-us.net> <52203CF0.5040600@asianux.com> <52207F74.6000702@roeck-us.net> <CAFLxGvyExTMSWOppheCwDA8RorSu_mLqW9a3f3GKFrsA2xbkfA@mail.gmail.com> <52208DFD.20105@roeck-us.net> <52240566.3040201@asianux.com> <52259DDE.6070401@asianux.com> <5225A3F8.5070008@huawei.com> <5225A685.5040507@asianux.com> <alpine.LNX.2.00.1309031126250.20551@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1309031126250.20551@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 05:27 PM, Jiri Kosina wrote:
> On Tue, 3 Sep 2013, Chen Gang wrote:
> 
>> Do you mean "coding style", not "colding style"? (or it is my
>> misunderstanding?).
>>
>>
>>> You're not going to run checkpatch.pl on the whole kernel tree and fix
>>> all the complaints, are you?
>>>
>>
>> I am not going to, it seems that may be the 'job' of Joe and
>> trivial@kernel.org?
> 
> FWIW, I am not generally accepting pure code reformatting patches.
> 

Yes, it is really not quite efficient to only accept pure code
reformatting patches (it must contain another 'things').
;-)


Thanks.
-- 
Chen Gang
