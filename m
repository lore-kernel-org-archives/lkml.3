Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3AXMTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:19:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56920 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab3AXMTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:19:09 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAPM=9tzqfDb7wtwRbDcYYcoB_HBLWksP8NYggsfj_GcNu=CY-A@mail.gmail.com>
References: <1359001345-3446-1-git-send-email-airlied@gmail.com> <b2122295-0a35-4aba-90f3-8306b92af78b@email.android.com> <CAPM=9tzqfDb7wtwRbDcYYcoB_HBLWksP8NYggsfj_GcNu=CY-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vgacon/vt: clear buffer attributes when we load a 512 character font
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 24 Jan 2013 06:18:58 -0600
To: Dave Airlie <airlied@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Message-ID: <1ef10934-f81f-4a4b-b4a9-4d499e9721bc@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The characters will morph anyway, it is just a matter off having them randomly scream with the intensity bit.

512-character mode is definitely useful... we get much wider language coverage with 512 than with 256, which is why most distros use a 512 console font.

Dave Airlie <airlied@gmail.com> wrote:

>On Thu, Jan 24, 2013 at 3:20 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> We should clear this bit presumably on switching either from or to
>512-char mode, since the bit doesn't really make sense either way.
>
>Yeah the only problem going from 512-char is that chars above 256 will
>morph into garbage chars below 256, like ctrl chars, I don't really
>want to face into doing some sort of safe translation out of 512-char
>mode, from reading around the net, 512 char mode doesn't seem all that
>brilliantly useful.
>
>Dave.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
