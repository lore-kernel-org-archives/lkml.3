Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966009Ab3E2M2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:28:15 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965860Ab3E2M2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:28:14 -0400
Message-ID: <51A5F456.7030408@nod.at>
Date: Wed, 29 May 2013 14:28:06 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Thomas Weber <thomas@tomweber.eu>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        wang bo <wang.bo116@zte.com.cn>
Subject: Re: [PATCH] UBI: Fastmap: Fix memory leak
References: <CAFLxGvw5gj-dfQeMKQVJpHPAXi4ZeNTaG3u3yXOAkshJRavXVA@mail.gmail.com>  <1369641744-13534-1-git-send-email-thomas@tomweber.eu>  <51A3150C.7080009@nod.at> <1369830446.24286.20.camel@sauron.fi.intel.com>
In-Reply-To: <1369830446.24286.20.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.05.2013 14:27, schrieb Artem Bityutskiy:
> On Mon, 2013-05-27 at 10:10 +0200, Richard Weinberger wrote:
>> Hi!
>>
>> Am 27.05.2013 10:02, schrieb Thomas Weber:
>>> Signed-off-by: wang bo <wang.bo116@zte.com.cn>
>>>
>>> [fix whitespace errors]
>>>
>>> Tested with linux-v3.10-rc3 on Devkit8000.
>>> Signed-off-by: Thomas Weber <thomas@tomweber.eu>
>>>
>>> The discussion about this patch can be found:
>>> https://lkml.org/lkml/2013/5/2/118
>>
>> Thanks a lot for fixing the whitespace issues!
>> Am I allowed to add a Tested-by: Thomas Weber <thomas@tomweber.eu>?
>> IOW did you test the patch? :D
>
> Did you intend to re-send the patch with all the tags at proper places?

Yes. But after I've tested it.
Currently I'm very busy. But starting with next week I'll have more time.

Thanks,
//richard

