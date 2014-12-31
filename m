Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaLaV2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 16:28:08 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:42214 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaLaV2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 16:28:07 -0500
MIME-Version: 1.0
In-Reply-To: <1420060806.6066.1.camel@perches.com>
References: <1420060243-10685-1-git-send-email-lstoakes@gmail.com>
	<1420060243-10685-2-git-send-email-lstoakes@gmail.com>
	<1420060806.6066.1.camel@perches.com>
Date: Wed, 31 Dec 2014 21:28:06 +0000
Message-ID: <CAA5enKZgR7a4cyKsM7MWrkR=KwP40tigViYpEU7=_6ZyYvk6sw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] staging: rtl8192u: fix whitespace
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, Ana Rey <anarey@gmail.com>,
        mcgrof@do-not-panic.com, tapaswenipathak@gmail.com,
        Rui Silva <rmfrfs@gmail.com>, Jiayi Ye <yejiayily@gmail.com>,
        Greg Donald <gdonald@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 December 2014 at 21:20, Joe Perches <joe@perches.com> wrote:

> It'd be nicer to use the same form and indentation
> for both entries.
>
> Probably be nicer to use:
>
> static u32 edca_setting_DL[HT_IOT_PEER_MAX] = {
>         0x5e4322, 0x5e4322, 0x5e4322, 0x604322, 0x00a44f, 0x5ea44f
> };
> static u32 edca_setting_UL[HT_IOT_PEER_MAX] = {
>         0x5e4322, 0x00a44f, 0x5e4322, 0x604322, 0x5ea44f, 0x5ea44f
> };
>
> so that the entries align too.

Ack... I am a bit of a beginner at the kernel, I think you can tell
;-) I didn't mean for this to have different indentation, in fixing up
other issues I missed this one, will fix. Will also add the 00 prefix,
good idea (+ update the commit message to accommodate.)

>
> Would it be better to use const?
>

I think this would be better as a separate patch as that is getting
into changing actual semantics rather than just simple style fixes,
there is a lot that could be improved here in that realm I think :)

Best, Lorenzo
