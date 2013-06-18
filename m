Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab3FRTwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:52:41 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:35036 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3FRTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:52:39 -0400
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EA2AA2513@SC-VEXCH1.marvell.com>
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
Date: Tue, 18 Jun 2013 12:52:37 -0700
X-Google-Sender-Auth: ixzXo_osiyttC08RhAsN6JJvul4
Message-ID: <CAD=FV=Xz-Cp86u=w8m91AEMJgH-o6cLkz6_udVw_3bm7Tm0OiA@mail.gmail.com>
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

On Tue, Jun 18, 2013 at 12:46 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Seungwon,
>
>> > I don't have the failing unit myself, so we'll have to get Bing to try
>> > the patches.  You are suggesting that we try applying both of your
>> > patches, right?
>> Did you test the patch?
>> I wonder that both are good for your side.
>
> I tested Doug's patch on my failing unit.
>
> Without this patch, mmc got hung_task and rebooted eventually.
> With this patch applied, mmc returns CRC error instead of hung_task, and the error is handled gracefully.

Have you tried one or both or Seungwon's fixes without mine?

-Doug
