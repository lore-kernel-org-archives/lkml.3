Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab3IGQwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 12:52:51 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:39604 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3IGQwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 12:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4Q85ewwKs7VoooZVapC7-Cvy6-Xp4rGL1-1Ee7w1EcT6w@mail.gmail.com>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
	<20130906202022.GA353@x4>
	<CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
	<CA+55aFzg-dv-N7UjXx2pxUJ+QQOOy0qtp_e94PDSM=tVd=LgUw@mail.gmail.com>
	<506b9d43-f734-40f9-b137-0749a496fd6d@email.android.com>
	<CA+55aFzLy+-VF022ORuyWk-qQO7gDSQ1LZES1+bEUxz0QxrH-g@mail.gmail.com>
	<20130907032240.GA1256@core.coreip.homeip.net>
	<CANq1E4Q85ewwKs7VoooZVapC7-Cvy6-Xp4rGL1-1Ee7w1EcT6w@mail.gmail.com>
Date: Sat, 7 Sep 2013 09:52:47 -0700
X-Google-Sender-Auth: Ee20v37CYJXc9vAV6lJYrGCtkgs
Message-ID: <CA+55aFye+TFiXPeJhB9fJjUcMR6LynjsZU+sjckKk2YoYOZDnw@mail.gmail.com>
Subject: Re: [GIT] HID for 3.12 merge window
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 12:31 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>
> The bug only occurs for multi-touch devices (their ABS_* bits are
>>0x1f), that's why I didn't see it happening during my tests..

It definitely affects keyboards too. That's how I noticed it. That is
with the logitech "universal" receiver, though, so maybe that counts
as a potential multi-touch device..

    Linus
