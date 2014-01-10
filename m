Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbaAJXAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 18:00:16 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:61964 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaAJXAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 18:00:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAK5ve-L4=uJmJfF67pR+jL1L532XP28FVmn=CTwWbDY2pUiPoA@mail.gmail.com>
References: <CAK5ve-L4=uJmJfF67pR+jL1L532XP28FVmn=CTwWbDY2pUiPoA@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 10 Jan 2014 14:59:52 -0800
Message-ID: <CAK5ve-LLdzEErKdDFoAb8kCLx7GMX5nXvO6opLzm4ZR0M-3dhw@mail.gmail.com>
Subject: Re: [GIT PULL] LED fix for 3.13
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My email was bounced back by LKML and Linux LED mail list. I forget to
use plain text mode. So I forward it again.

Thanks,
-Bryan

On Fri, Jan 10, 2014 at 2:57 PM, Bryan Wu <cooloney@gmail.com> wrote:
>
> Hi Linus,
>
> Pali Rohár and Pavel Machek reported the LED of Nokia N900 doesn't work with our latest 3.13-rc6 kernel. Milo fixed the regression here.
>
> So please consider the following changes since commit 802eee95bde72fd0cd0f3a5b2098375a487d1eda:
>
>   Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git leds-fixes-for-3.13
>
> for you to fetch changes up to e70988d1aaf73221355e06125c9937bd4b27761c:
>
>   leds: lp5521/5523: Remove duplicate mutex (2014-01-10 14:48:07 -0800)
>
> ----------------------------------------------------------------
> Milo Kim (1):
>       leds: lp5521/5523: Remove duplicate mutex
>
>  drivers/leds/leds-lp5521.c | 12 ++++--------
>  drivers/leds/leds-lp5523.c | 12 ++++--------
>  2 files changed, 8 insertions(+), 16 deletions(-)
