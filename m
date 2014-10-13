Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaJMP6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:58:09 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33208 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaJMP6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:58:07 -0400
Message-ID: <543BF67E.3080506@roeck-us.net>
Date: Mon, 13 Oct 2014 08:57:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Romain Francoise <romain@orebokech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
References: <20141013022454.289398272@linuxfoundation.org> <87d29w6kl8.fsf@kima.orebokech.com>
In-Reply-To: <87d29w6kl8.fsf@kima.orebokech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.543BF68F.013A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 17
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

On 10/13/2014 08:44 AM, Romain Francoise wrote:
> On Mon, Oct 13, 2014 at 04:24:53AM +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.17.1 release.
>> There are 25 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>
> Commit 1c40279960 ("libata: Un-break ATA blacklist") is apparently not
> included, is in Linus' tree since Friday, and is rather urgent.
>

Partly unrelated, but if you send me a qemu config and qemu command line
to test if the blacklist is working (one which fails if it doesn't),
I'll be happy to add it to my automated tests.

Guenter

