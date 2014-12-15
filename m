Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaLOEUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 23:20:00 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:49931 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLOET6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 23:19:58 -0500
MIME-Version: 1.0
In-Reply-To: <CA+i0qc5MF9_siN05VEOtOdPQfByt1UHEpbwVkYQ5+EObF6H4nQ@mail.gmail.com>
References: <CA+i0qc5MF9_siN05VEOtOdPQfByt1UHEpbwVkYQ5+EObF6H4nQ@mail.gmail.com>
Date: Mon, 15 Dec 2014 13:19:56 +0900
Message-ID: <CAP2JTQLouqV-xCPugy4uK_J1gRpa78VKeaVy2AdDiXR4MO3dwQ@mail.gmail.com>
Subject: Re: UFS RPMB
From: Kyuho Choi <chlrbgh0@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As i know, SECURITY PROTOCOL IN/OUT are support RPMB access for UFS.

On 12/14/14, Tomas Winkler <tomasw@gmail.com> wrote:
> Hi, sorry fore a newbie question.
> What is the current interface for accessing rpmb LUN in a UFS devices.
> For emmc one need to issue a raw mmc ioctl command  MMC_IOC_CMD.
>
> Thanks
> Tomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
