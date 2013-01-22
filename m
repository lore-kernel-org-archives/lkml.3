Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3AVSkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:40:17 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:37160 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab3AVSkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:40:13 -0500
MIME-Version: 1.0
In-Reply-To: <201301221937.16916.chunkeey@googlemail.com>
References: <1358879444-25834-1-git-send-email-keescook@chromium.org>
	<1358879444-25834-17-git-send-email-keescook@chromium.org>
	<201301221937.16916.chunkeey@googlemail.com>
Date: Tue, 22 Jan 2013 10:40:12 -0800
X-Google-Sender-Auth: WIbbR65djK5zn0p3fGGhPX7wwCA
Message-ID: <CAGXu5jJCQshUntUk7MeZds59B2fa54GnonOz28dM1x2spEEGDg@mail.gmail.com>
Subject: Re: [PATCH 16/20] drivers/net/wireless/p54: remove depends on CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:37 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> Aren't these patches going through wireless-next
> or linux-next?

They can go however it makes things easiest. Greg has offered to carry
them in driver-core if Dave doesn't want to carry them in netdev.

-Kees

>
> On Tuesday, January 22, 2013 07:30:40 PM Kees Cook wrote:
>> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
>> while now and is almost always enabled by default. As agreed during the
>> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>>
>> CC: Christian Lamparter <chunkeey@googlemail.com>
>> CC: "John W. Linville" <linville@tuxdriver.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: NetDev <netdev@vger.kernel.org>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>
> [Also ACK the carl9170, if necessary]
>
> Regards,
>         Chr



--
Kees Cook
Chrome OS Security
