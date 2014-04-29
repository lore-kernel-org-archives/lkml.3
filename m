Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbaD2SEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:04:41 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51230 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933510AbaD2SEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:04:40 -0400
MIME-Version: 1.0
In-Reply-To: <s5hbnvk9pxn.wl%tiwai@suse.de>
References: <CAAWf5=s-hQ2xMtLxNFXjXH6UGmQtgkrzS9zWj3z_CTq41XGpdw@mail.gmail.com>
 <s5h4n1ov8h9.wl%tiwai@suse.de> <CAAWf5=usG_Q-11kMd=58mVEELb8b0nyBXanaDqKqCGSFVJP0Rw@mail.gmail.com>
 <s5hbnvk9pxn.wl%tiwai@suse.de>
From: Bryan Quigley <gquigs@gmail.com>
Date: Tue, 29 Apr 2014 14:04:15 -0400
Message-ID: <CAAWf5=tENLeh8VeM2i_FwYiqGYtZEMZ625XQTjx6nutE=A46Mg@mail.gmail.com>
Subject: Re: PROBLEM: Pulseaudio hung at schedule in 3.15-rc1
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pastebined the full boots syslog here: http://pastebin.ubuntu.com/7360925/

The only kernel error I get is that pulseaudio hangs.. Nothing more
specific as to why.
I can also get a hang if I just run: sudo lsusb -v.  It displays
Bus 002 Device 002: ID 046d:0825 Logitech, Inc. Webcam C270
[blinking cursor]

Thanks,
Bryan


> Now I'm back and start looking at this again.
> Could you give the raw kernel messages with the stack trace?
> The previous cited message is hard to read.
>
>> I did determine it is caused by having my Logitech webcam plugged in.
>> Here is lsusb from a working system:
>> Bus 002 Device 002: ID 046d:0825 Logitech, Inc. Webcam C270
>
> OK, there is a quick for this device but it shouldn't affect the
> suspend/resume behavior, at least.
