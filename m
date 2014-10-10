Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaJJQCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 12:02:35 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:45456 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaJJQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 12:02:32 -0400
Message-ID: <54380310.8000304@roeck-us.net>
Date: Fri, 10 Oct 2014 09:02:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Josh Boyer <jwboyer@fedoraproject.org>, torvalds@linuxfoundation.org,
        Josh Cartwright <joshc@codeaurora.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: pinctrl-msm build error on Linus' tree
References: <CA+5PVA4mO+BiTGvrRb7-MLZRV1iQKsmvaDifFLQiqZN1-b88RQ@mail.gmail.com>	<20141008231208.GB25134@roeck-us.net>	<CACRpkdZHHPvJiYmAvYdGb01sKsSmkfuV+d4-skSePbFFEjYs2g@mail.gmail.com>	<20141009160737.GE31987@roeck-us.net> <CACRpkdZ8RH78Nx5rNeRv0Z-_Pk0yyd9b8X9eqxgCUnv1nVos-Q@mail.gmail.com>
In-Reply-To: <CACRpkdZ8RH78Nx5rNeRv0Z-_Pk0yyd9b8X9eqxgCUnv1nVos-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54380315.0283,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 10/10/2014 01:42 AM, Linus Walleij wrote:
> On Thu, Oct 9, 2014 at 6:07 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>
>> But then Linus ignored my pull request (so far), so maybe I did manage to
>> upset him ;-).
>
> Did you send it as a separate mail with [GIT PULL] in the Subject:?
>

Yes, I did. Two, actually, one for the reset handler and one for the hwmon subsystem.

Guenter

