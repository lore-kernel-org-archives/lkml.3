Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaFORgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:36:50 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:53904 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaFORgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:36:48 -0400
MIME-Version: 1.0
In-Reply-To: <1402778036.2756.24.camel@joe-AO725>
References: <1402776434-31613-1-git-send-email-cengelma@gmx.at>
	<1402778036.2756.24.camel@joe-AO725>
Date: Sun, 15 Jun 2014 23:06:46 +0530
Message-ID: <CAK5sBcGu2vFQFxqETgbLnu0AoMAhn9Zq5SEWNNzX=mr0yuWRdg@mail.gmail.com>
Subject: Re: [PATCH] serial: samsung: Fix compile error with SERIAL_SAMSUNG_DEBUG
From: Sachin Kamat <spk.linux@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Christian Engelmayer <cengelma@gmx.at>, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 2:03 AM, Joe Perches <joe@perches.com> wrote:
> Greg?  Can you please apply this soon?

A similar patch has already been posted [1]. Probably Greg will apply it
once 3.16-rc1 is out.

[1] http://www.spinics.net/lists/linux-serial/msg12843.html

Regards,
Sachin.


>
> Thanks.
>
> On Sat, 2014-06-14 at 22:07 +0200, Christian Engelmayer wrote:
>> Commit e4ac92d (serial: samsung: Neaten dbg uses) contains a typo in the
>> changed dbg() function regarding the name of the used character buffer.
>> This breaks the build if actually compiled with CONFIG_SERIAL_SAMSUNG_DEBUG.
>>
>> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
