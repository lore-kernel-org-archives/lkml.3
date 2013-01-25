Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3AYC1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:27:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37417 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab3AYC1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:27:23 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAPM=9tyfxWBrqJM64B_VV0+KispQBSixVzdmhFocxmt9WNYEwg@mail.gmail.com>
References: <1359001345-3446-1-git-send-email-airlied@gmail.com> <b2122295-0a35-4aba-90f3-8306b92af78b@email.android.com> <CAPM=9tzqfDb7wtwRbDcYYcoB_HBLWksP8NYggsfj_GcNu=CY-A@mail.gmail.com> <1ef10934-f81f-4a4b-b4a9-4d499e9721bc@email.android.com> <CAPM=9tyfxWBrqJM64B_VV0+KispQBSixVzdmhFocxmt9WNYEwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vgacon/vt: clear buffer attributes when we load a 512 character font
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 24 Jan 2013 20:26:16 -0600
To: Dave Airlie <airlied@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Message-ID: <3e1239db-9a17-46b1-ab67-8934c4fe5938@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice to support more than 512 characters when using a graphical console.  We should be able to support up to 2048 at least.

Dave Airlie <airlied@gmail.com> wrote:

>On Thu, Jan 24, 2013 at 10:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> The characters will morph anyway, it is just a matter off having them
>randomly scream with the intensity bit.
>>
>> 512-character mode is definitely useful... we get much wider language
>coverage with 512 than with 256, which is why most distros use a 512
>console font.
>
>Yeah really use a graphics console :-)
>
>But I've sent a v2 patch that should clear the attribute space going
>both directions.
>
>Dave.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
