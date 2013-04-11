Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3DKUR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:17:58 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:43927 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3DKURz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:17:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=X6BBWJMDzJR9tnjKj8xTZ3Ng9oS7PYtNdUenW7_86vqw@mail.gmail.com>
References: <1365705391-23181-1-git-send-email-abrestic@chromium.org>
	<CAD=FV=X6BBWJMDzJR9tnjKj8xTZ3Ng9oS7PYtNdUenW7_86vqw@mail.gmail.com>
Date: Thu, 11 Apr 2013 13:17:54 -0700
X-Google-Sender-Auth: eOAer7FwjEPIbapBdEdcu-FSZLM
Message-ID: <CAL1qeaGjK0+hSTNbo0=zfSYtBJKcaKgi_Opi9ost4az96H=Cjg@mail.gmail.com>
Subject: Re: [PATCH] backlight: platform_lcd: introduce probe callback
From: Andrew Bresticker <abrestic@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-fbdev@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would probably be good not to print in the case of -EPROBE_DEFER?

Actually, I think I'll just kill the print all together since the
caller will print something anyways.

-Andrew
