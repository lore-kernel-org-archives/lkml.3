Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaGHO66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:58:58 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60115 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaGHO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:58:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAAsK9AFfn45wyQFsOiCAZXZjXfyPLhz3FxyBO5P_q_48s9ce_g@mail.gmail.com>
References: <1404828488-7649-1-git-send-email-andrey.krieger.utkin@gmail.com>
	<CAAsK9AFfn45wyQFsOiCAZXZjXfyPLhz3FxyBO5P_q_48s9ce_g@mail.gmail.com>
Date: Tue, 8 Jul 2014 17:58:55 +0300
Message-ID: <CANZNk82w4_EQCJ9TigTymAVjCbQqXVDDQFH4mpZ6W3b3qwj_tA@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci-vpfe: Fix retcode check
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Levente Kurusa <lkurusa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Linux Media <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        prabhakar.csengg@gmail.com, Josh Triplett <josh@joshtriplett.org>,
        Archana Kumari <archanakumari959@gmail.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-08 17:32 GMT+03:00 Levente Kurusa <lkurusa@redhat.com>:
> Hmm, while it is true that get_ipipe_mode returns an int, but
> the consequent call to regw_ip takes an u32 as its second
> argument. Did it cause a build warning for you? (Can't really
> check since I don't have ARM cross compilers close-by)
> If not, then:

Cannot say for sure would compiler complain.
I also haven't really checked it, and unfortunately even haven't
succeeded to make a config that would build that code. But i believe
that warning is still better than misbehaviour.

-- 
Andrey Utkin
