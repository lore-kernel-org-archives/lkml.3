Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaIDQnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:43:45 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:41899 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaIDQno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:43:44 -0400
MIME-Version: 1.0
In-Reply-To: <1409848803-17893-1-git-send-email-linux@roeck-us.net>
References: <1409848803-17893-1-git-send-email-linux@roeck-us.net>
Date: Thu, 4 Sep 2014 09:43:43 -0700
X-Google-Sender-Auth: Gmbe43xrzDGCs7i2o3iBGZmgeiM
Message-ID: <CA+55aFwEDkjkuSfLufqyHhGYxJhXVeh56JXE5Fbo4v29YRcb=A@mail.gmail.com>
Subject: Re: [GIT PULL resend] hwmon fixes for 3.17-rc4
From: Linus Torvalds <linus@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 9:40 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> I know my e-mail service is acting up again, so I don't know if there
> is a problem with linux-foundation.org or with my e-mail service or if I
> should have used linuxfoundation.org all along

There's some silly DNS problem with "linux-foundation.org" - it's
*supposed* to alias to the non-dashed version, but somehow that alias
disappeared. It hopefully gets fixed soon, in the meantime people get
bounces. Oh well.

                Linus
