Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaKRESx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 23:18:53 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:45280 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaKRESw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 23:18:52 -0500
Message-ID: <546AC8A4.4030705@roeck-us.net>
Date: Mon, 17 Nov 2014 20:18:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@opensource.altera.com>
Subject: Re: [PATCH] regulator: Ensure unique regulator debugfs directory
 names
References: <1413559023-18293-1-git-send-email-linux@roeck-us.net> <20141117210009.GA28122@roeck-us.net> <20141117232620.GA22111@sirena.org.uk>
In-Reply-To: <20141117232620.GA22111@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.546AC8AB.0148,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2014 03:26 PM, Mark Brown wrote:
> On Mon, Nov 17, 2014 at 01:00:09PM -0800, Guenter Roeck wrote:
>> On Fri, Oct 17, 2014 at 08:17:03AM -0700, Guenter Roeck wrote:
>
>>> To avoid the problem, prepend the debugfs directory name for a regulator
>>> with its parent device name if available, but only if no explicit
>>> regulator name was provided.
>
>> Hi Mark,
>>
>> did you have time to look into this patch ?
>
> Please don't send contentless, quoted pings.  One of two things will be
> true: either your patch got lost in which case a quoted copy is of no
> use in getting the patch applied or the patch is buried under other mail
> in which case you are at best adding to the email volume and at worst
> your mail will never be seen as it's threaded in with the original send.
>

Hi Mark,

Sorry, I have no idea how you expect me (and others) to handle situations
like this, much less with this patch. Please keep in mind that this is
a per-maintainer process, and each maintainer handles things differently.
Individual maintainers may expect me to send a ping like I did, or to
resend the patch, or they may not reply because they dislike the patch
and they don't want to be bothered with a discussion. Some even go
ballistic if they get an e-mail with more than 80 columns of text.

Negotiating a minefield sometimes seems easier than submitting kernel
patches :-(.

I can't even find out by browsing the regulator mailing list since it
appears that there is no such list.

Guenter

