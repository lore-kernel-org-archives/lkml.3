Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbbAWDa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 22:30:59 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:58776 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbbAWDax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 22:30:53 -0500
Message-ID: <54C1C04C.40205@ahsoftware.de>
Date: Fri, 23 Jan 2015 04:30:20 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: Paul Moore <pmoore@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: weird and wrong directory entries
References: <20150123004138.GA2626@swordfish> <20150123013053.GY29656@ZenIV.linux.org.uk> <20150123020644.GA466@swordfish>
In-Reply-To: <20150123020644.GA466@swordfish>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.01.2015 um 03:06 schrieb Sergey Senozhatsky:
> On (01/23/15 01:30), Al Viro wrote:
>> On Fri, Jan 23, 2015 at 09:42:21AM +0900, Sergey Senozhatsky wrote:
>>> Hello gents,
>>>
>>> I observe this sick behaviour for the past few days. (sorry, some lines are
>>> over 80 symbols). all of the things above are happening during kernel compilation.
>>> attached .config.
>>
>>> happens both on reiserfs and ext4, both on current linus's tree and linux-next.
>>> no doubt, an attempt to rm -fr pkg/   kills   /usr/, etc.
>>>
>>
>>> I'm puzzled. any thoughts?
>>
>> Try to bisect, perhaps?
>>

There are some weird pieces in the kernel buildsysten which are
generating Makefile content based on some filenames and might brake or
confuse future builds. See e.g. https://lkml.org/lkml/2014/10/19/10.

Maybe you've stumbled over a similiar thing.

Regards,

Alexander Holler

