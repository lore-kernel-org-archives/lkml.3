Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaLCMjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:39:09 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:49639 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaLCMjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:39:07 -0500
X-IronPort-AV: E=Sophos;i="5.07,507,1413270000"; 
   d="scan'208";a="52152486"
Message-ID: <547F0465.407@broadcom.com>
Date: Wed, 3 Dec 2014 13:39:01 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: SF Markus Elfring <elfring@users.sourceforge.net>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Julia Lawall <julia.lawall@lip6.fr>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Coccinelle <cocci@systeme.lip6.fr>, <backports@vger.kernel.org>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [patch] CodingStyle: add some more error handling guidelines
References: <20141202085950.GA13434@mwanda> <547F0297.6030202@users.sourceforge.net>
In-Reply-To: <547F0297.6030202@users.sourceforge.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 13:31, SF Markus Elfring wrote:
>> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
>> index 9f28b14..9c8a234 100644
>> --- a/Documentation/CodingStyle
>> +++ b/Documentation/CodingStyle
>> @@ -392,7 +392,12 @@ The goto statement comes in handy when a function exits from multiple
>>   locations and some common work such as cleanup has to be done.  If there is no
>>   cleanup needed then just return directly.
>>
>> -The rationale is:
>> +Choose label names which say what the goto does or why the goto exists.  An
>> +[...]  Avoid
>> +using GW-BASIC names like "err1:" and "err2:".  Also don't name them after the
>> +goto location like "err_kmalloc_failed:"
>
> I find this documentation approach not safe and clear enough so far.
>
> * How should the reference to an other programming language help in the understanding
>    of the recommended naming convention for jump labels?
>
> * To which source code place should the word "location" refer to?
>    - jump source
>    - jump target

I think you digested the paragraph in too small bits. The term "goto 
location" looks synonymous to "jump source" to me.

Regards,
Arend

> Regards,
> Markus
> --
> To unsubscribe from this list: send the line "unsubscribe backports" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

