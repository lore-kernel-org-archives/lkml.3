Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab3HWUkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:40:55 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:52994 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3HWUkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:40:53 -0400
MIME-Version: 1.0
In-Reply-To: <521761F1.60203@samsung.com>
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
	<1377188348-3418-3-git-send-email-dianders@chromium.org>
	<521761F1.60203@samsung.com>
Date: Fri, 23 Aug 2013 13:40:52 -0700
X-Google-Sender-Auth: 1yqVKUNGLLqkT4p3AAkbpcnC8sg
Message-ID: <CAD=FV=WrZacm7UUB3-qE=ufwkur_55m0puPNdUaGBYszPw9OdQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] mmc: dw_mmc: Honor requests to set the clock to 0
 (turn off clock)
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon,

On Fri, Aug 23, 2013 at 6:21 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi Doug,
>
> If the clock-gating is enabled, then maybe it's continuously printed the kernel message for Bus_speed.

Can you explain?  I don't think dw_mmc has support for clock gating
right now.  ...or are there some patches that I'm not aware of?  I
could believe that if you've got some non-upstream clock gating
patches that these would need to be modified to handle it...  ...but
unless those are slated to land upstream it seems like I can't take
them into account, can I?

Thanks!

-Doug
