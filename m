Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab3IGBAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 21:00:32 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:36642 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3IGBAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 21:00:30 -0400
MIME-Version: 1.0
In-Reply-To: <506b9d43-f734-40f9-b137-0749a496fd6d@email.android.com>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
	<20130906202022.GA353@x4>
	<CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
	<CA+55aFzg-dv-N7UjXx2pxUJ+QQOOy0qtp_e94PDSM=tVd=LgUw@mail.gmail.com>
	<506b9d43-f734-40f9-b137-0749a496fd6d@email.android.com>
Date: Fri, 6 Sep 2013 18:00:29 -0700
X-Google-Sender-Auth: 3W_cGFSvkGXxOupxysXTlyDDb2o
Message-ID: <CA+55aFzLy+-VF022ORuyWk-qQO7gDSQ1LZES1+bEUxz0QxrH-g@mail.gmail.com>
Subject: Re: [GIT] HID for 3.12 merge window
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 5:58 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> The patch still had problems so I'd revert it and wii bits and try again later.

Ok. Mind giving me a list of commits, so that I don't have to do a
trial-and-error thing? I know the primary commit that causes problems,
but there are commits that seem to depend on it..

             Linus
