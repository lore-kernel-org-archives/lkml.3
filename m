Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaGHPmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:42:04 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64060 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaGHPmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:42:02 -0400
MIME-Version: 1.0
In-Reply-To: <CANZNk82w4_EQCJ9TigTymAVjCbQqXVDDQFH4mpZ6W3b3qwj_tA@mail.gmail.com>
References: <1404828488-7649-1-git-send-email-andrey.krieger.utkin@gmail.com>
 <CAAsK9AFfn45wyQFsOiCAZXZjXfyPLhz3FxyBO5P_q_48s9ce_g@mail.gmail.com> <CANZNk82w4_EQCJ9TigTymAVjCbQqXVDDQFH4mpZ6W3b3qwj_tA@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 8 Jul 2014 16:41:30 +0100
Message-ID: <CA+V-a8tcmxovq-bPO9RV9X74w66HgCR9ViBDY7ezX29b6MSgyg@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci-vpfe: Fix retcode check
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: Levente Kurusa <lkurusa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Linux Media <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Archana Kumari <archanakumari959@gmail.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

Thanks for the patch!

On Tue, Jul 8, 2014 at 3:58 PM, Andrey Utkin
<andrey.krieger.utkin@gmail.com> wrote:
> 2014-07-08 17:32 GMT+03:00 Levente Kurusa <lkurusa@redhat.com>:
>> Hmm, while it is true that get_ipipe_mode returns an int, but
>> the consequent call to regw_ip takes an u32 as its second
>> argument. Did it cause a build warning for you? (Can't really
>> check since I don't have ARM cross compilers close-by)
>> If not, then:
>
> Cannot say for sure would compiler complain.
> I also haven't really checked it, and unfortunately even haven't
> succeeded to make a config that would build that code. But i believe
> that warning is still better than misbehaviour.
>
It wont cause any compile warning.

Applied for v3.17

Thanks,
--Prabhakar Lad
