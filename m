Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaGJR3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:29:50 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:40731 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGJR3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:29:49 -0400
MIME-Version: 1.0
In-Reply-To: <1405012838-31015-1-git-send-email-olof@lixom.net>
References: <1405012838-31015-1-git-send-email-olof@lixom.net>
Date: Thu, 10 Jul 2014 10:29:48 -0700
X-Google-Sender-Auth: qzL9g_T-z0SjVMwmUkIMdiEFZ5s
Message-ID: <CANLzEksAZEkFa8jGSSzMgnAy6n+JUJXx+xHOhPnHN2Qh+eY4CA@mail.gmail.com>
Subject: Re: [PATCH] platform/chrome: pstore: fix dmi table to match all
 chrome systems
From: Benson Leung <bleung@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 10:20 AM, Olof Johansson <olof@lixom.net> wrote:
> Turns out that DMI_SYSTEM_VENDOR is actually the native vendor of each
> Chromebook/box. I tested the original patch on a Pixel that -- surprise,
> has Google as vendor. *facepalm*.
>
> The only other data I can think of to probe on is Google_* in the version
> string.  Checking with our firmware team, all systems should have this
> and nothing else than Chrome hardware should have the coreboot + Google_*
> combination to date.
>
> So, we'll switch to this. For future platforms we are going to move to
> using an ACPI device to configure this instead of a DMI table (yay!),
> so longer-term that will sort itself out.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>

Reviewed-by: Benson Leung <bleung@chromium.org>


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
