Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3E0I3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:29:06 -0400
Received: from 81-89-104-214.blue.kundencontroller.de ([81.89.104.214]:59435
	"EHLO tomweber.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab3E0I3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:29:05 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2013 04:29:05 EDT
To: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] UBI: Fastmap: Fix memory leak
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 27 May 2013 10:22:32 +0200
From: Thomas Weber <thomas@tomweber.eu>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, wang bo <wang.bo116@zte.com.cn>
In-Reply-To: <51A3150C.7080009@nod.at>
References: <CAFLxGvw5gj-dfQeMKQVJpHPAXi4ZeNTaG3u3yXOAkshJRavXVA@mail.gmail.com>
 <1369641744-13534-1-git-send-email-thomas@tomweber.eu>
 <51A3150C.7080009@nod.at>
Message-ID: <03cfc90681a75058e41a4d80a8c33f2f@tomweber.eu>
User-Agent: Roundcube Webmail/0.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2013-05-27 10:10, Richard Weinberger wrote:
> Hi!
> 
> Am 27.05.2013 10:02, schrieb Thomas Weber:
>> Signed-off-by: wang bo <wang.bo116@zte.com.cn>
>> 
>> [fix whitespace errors]
>> 
>> Tested with linux-v3.10-rc3 on Devkit8000.
>> Signed-off-by: Thomas Weber <thomas@tomweber.eu>
>> 
>> The discussion about this patch can be found:
>> https://lkml.org/lkml/2013/5/2/118
> 
> Thanks a lot for fixing the whitespace issues!
> Am I allowed to add a Tested-by: Thomas Weber <thomas@tomweber.eu>?
> IOW did you test the patch? :D

You can add my Tested-by.
Thomas

> 
> Thanks,
> //richard
