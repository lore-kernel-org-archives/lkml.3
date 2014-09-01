Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaIALzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:55:54 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:47300 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaIALzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:55:53 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: migueloliv@gmail.com
In-Reply-To: <20140901095446.GF5122@mwanda>
References: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
	<1408703617-32248-1-git-send-email-cmroliv@gmail.com>
	<20140830204109.GC16168@kroah.com>
	<CAMGgR5tmQE2nWJwBkc5jv_TF=xM+XRf6exGUOA6A-X+7iXqbFg@mail.gmail.com>
	<20140901095446.GF5122@mwanda>
Date: Mon, 1 Sep 2014 13:55:52 +0200
X-Google-Sender-Auth: lVJHibEx4RTL78Qqo8SaTkLbQcg
Message-ID: <CAMGgR5vActZ6Cnv4LCvj1YQSmP26qCc4rps7iPkNhuTvQoVTrg@mail.gmail.com>
Subject: Re: [PATCH 3/4] staging: rtl8188eu: osdep_intf.h and usb_intf.c
From: Miguel Oliveira <cmroliv@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Same comments as the previous ones, please redo all of these patches.
>> >
>> Should all the alterations be in one big single patch, insted of small ones?
>
> Your first version broke the build if we applied only the first patch.
> That's not allowed.
I now understand that, thank you.

> Also the new rtw_sys_remove_one() function isn't called.  I was confused
> by it as well.  It doesn't "remove one", it removes everything.
The function it's not new, I just converted it from the proc to
defugfs, It can be renamed.

> Do we need to support llseek?
Probably not... I'll check it.

> How have you tested this?  Have you tested module unloading?
Yes, I've tested it several times and unloaded without issues.

Thank you for your comments,
Best Regards,
Miguel Oliveira
