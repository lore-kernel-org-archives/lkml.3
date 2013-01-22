Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3AVHdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:33:12 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36425 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3AVHdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:33:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAL7WMDcf-c96x9eM2283L5qSWuJtJ3RgPN9QpCNcVTyVaAhnNA@mail.gmail.com>
References: <CAL7WMDcf-c96x9eM2283L5qSWuJtJ3RgPN9QpCNcVTyVaAhnNA@mail.gmail.com>
Date: Tue, 22 Jan 2013 13:03:08 +0530
Message-ID: <CAK7N6vo1e4RCRH9=TmXcPnsY9n3pUxh=B8_eE8t2W3LYZ1AngQ@mail.gmail.com>
Subject: Re: Can jiffies freeze?
From: anish singh <anish198519851985@gmail.com>
To: sandeep kumar <coolsandyforyou@gmail.com>
Cc: "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:21 AM, sandeep kumar
<coolsandyforyou@gmail.com> wrote:
> Hi all
> As far as I know jiffie counter is incremented HZ times/second. And it is
> used to measure the time lapses in the kernel code.
>
> I m seeing a case where, actualy time spent in some module using giffies is
> zero, but while seeing UART logs i am seein 2 sec time difference. I dont
Please post the code here regarding how did you find out it is zero.
> know how to interpret this. The case which i am seeing, hrtimers are not
> enabled yet, so only thing i can rely are on jiffies.
>
> My question here is,
> Is it possible that the measured time lapse shown is "0"(jiffie count is
> same before and after), but actually some time is spent?(say some 2 sec)
>
> In another way..can jiffies may freeze for some time?
Is your watchdog enabled?If it is then you will see panic happening
i.e. soft lockup.
>
> Please clarify...
>
>
> --
> With regards,
> Sandeep Kumar Anantapalli,
>
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
>
