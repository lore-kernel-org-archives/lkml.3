Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422962Ab3FUDeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 23:34:02 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:34077 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422652Ab3FUDeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 23:34:00 -0400
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EA2AA251A@SC-VEXCH1.marvell.com>
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
	<5146EAB0.1030705@samsung.com>
	<CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
	<515E88E3.5070507@samsung.com>
	<003401ce3453$19d1e8c0$4d75ba40$%jun@samsung.com>
	<CAD=FV=V+ZZ0MUtuWKUOgR9NPyAquUjFC6KtHvAP-4iHXAYpjqA@mail.gmail.com>
	<001601ce35b9$652c5870$2f850950$%jun@samsung.com>
	<CAD=FV=XKeRjpH1+ytjMfLuGGqQ5VVub22n=V+UpV=jBCD4LLHw@mail.gmail.com>
	<001801ce6c20$6ba39900$42eacb00$%jun@samsung.com>
	<477F20668A386D41ADCC57781B1F70430EA2AA2513@SC-VEXCH1.marvell.com>
	<CAD=FV=Xz-Cp86u=w8m91AEMJgH-o6cLkz6_udVw_3bm7Tm0OiA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430EA2AA251A@SC-VEXCH1.marvell.com>
Date: Thu, 20 Jun 2013 20:33:58 -0700
X-Google-Sender-Auth: Zuhs51kUABoLO9Ux1YdqCZlFKPc
Message-ID: <CAD=FV=V6S7FsK+=+7EHDV74=Mw_iWecO2ZxVpVcd=p7ugW-sHA@mail.gmail.com>
Subject: Re: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from STATE_DATA_ERROR
From: Doug Anderson <dianders@chromium.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Will Newton <will.newton@gmail.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Paul Stewart <pstew@chromium.org>, Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bing,

On Tue, Jun 18, 2013 at 1:01 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Doug,
>
>> > I tested Doug's patch on my failing unit.
>> >
>> > Without this patch, mmc got hung_task and rebooted eventually.
>> > With this patch applied, mmc returns CRC error instead of hung_task, and the error is handled
>> gracefully.
>>
>> Have you tried one or both or Seungwon's fixes without mine?
>
> I only tested your original patch. That was several months ago I think.
>
> I still have that unit. Let me know if you want me to try Seungwon's patches.

I think the proposal on the table is to take Seungwon's patches
instead of mine.  Assuming they solve your problems, I'm OK with that.
 I think he was requesting testing the first of his two patches alone
and then both of his two patches together.

Thanks!

-Doug
