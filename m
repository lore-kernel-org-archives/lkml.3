Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaLOJ07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:26:59 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60067 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaLOJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:26:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAP2JTQLouqV-xCPugy4uK_J1gRpa78VKeaVy2AdDiXR4MO3dwQ@mail.gmail.com>
References: <CA+i0qc5MF9_siN05VEOtOdPQfByt1UHEpbwVkYQ5+EObF6H4nQ@mail.gmail.com>
	<CAP2JTQLouqV-xCPugy4uK_J1gRpa78VKeaVy2AdDiXR4MO3dwQ@mail.gmail.com>
Date: Mon, 15 Dec 2014 11:26:54 +0200
Message-ID: <CA+i0qc6n-6zoOFg-PRrv2=w9Qod5hDKK+nvJ0GH4DmtPNW-R4g@mail.gmail.com>
Subject: Re: UFS RPMB
From: Tomas Winkler <tomasw@gmail.com>
To: Kyuho Choi <chlrbgh0@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you be more specific about Linux programming API
Thanks

On Mon, Dec 15, 2014 at 6:19 AM, Kyuho Choi <chlrbgh0@gmail.com> wrote:
> As i know, SECURITY PROTOCOL IN/OUT are support RPMB access for UFS.
>
> On 12/14/14, Tomas Winkler <tomasw@gmail.com> wrote:
>> Hi, sorry fore a newbie question.
>> What is the current interface for accessing rpmb LUN in a UFS devices.
>> For emmc one need to issue a raw mmc ioctl command  MMC_IOC_CMD.
>>
>> Thanks
>> Tomas
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
