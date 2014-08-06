Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaHFTEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:04:05 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:42574 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaHFTED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:04:03 -0400
MIME-Version: 1.0
Reply-To: markus@gutschke.com
In-Reply-To: <3611647.fAl6g4h0i8@vostro.rjw.lan>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
 <1407206650.10148.28.camel@rzhang1-toshiba> <CALGCz1pSpzDVb8sQx=QFKjdR4fi566h42p2nRkFx+RXairbgFQ@mail.gmail.com>
 <3611647.fAl6g4h0i8@vostro.rjw.lan>
From: Markus Gutschke <markus@gutschke.com>
Date: Wed, 6 Aug 2014 12:03:39 -0700
X-Google-Sender-Auth: FTDnXuAdoWzjTMMEYai5iBBKyew
Message-ID: <CALGCz1rdyqeK8c_Rtmu88umaZA-pV_2_Q7JcY-kFBwg+QRzArA@mail.gmail.com>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"platform" does in fact appear to cause a crash (at least, I can't
reach the machine anymore, after having suspended).

I am still on the road and have to do this remotely, and I cannot get
hold of my helper right now. I'll try again later tonight or maybe the
next day(s) and will get back to you with more data.


Markus
