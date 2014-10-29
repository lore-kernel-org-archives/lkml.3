Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaJ2Hgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:36:45 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:64065 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaJ2Hgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <2258102.tG8NmIz9Bk@wuerfel>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
	<1806277.3CF96bVORX@wuerfel>
	<1414492984.2295.8.camel@leyfoon-vm>
	<2258102.tG8NmIz9Bk@wuerfel>
Date: Wed, 29 Oct 2014 15:36:41 +0800
X-Google-Sender-Auth: 3WBdZPd4Lip0O5a4CufKy6f-3Rw
Message-ID: <CAFiDJ5-WPfyS8Zn+NRu4ps3LKbt9xhhe=3sO1ykOjhrqEZx3rA@mail.gmail.com>
Subject: Re: [PATCH v5 21/29] nios2: Time keeping
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 9:39 PM, Arnd Bergmann <arnd@arndb.de> wrote:

>> Hi Arnd,
>> No problem, I can change that. But, seem that we don't need to have
>> calibrate_delay_is_known() as well. We can just set "lpj_fine" variable,
>> arm64 uses this.
>
> Right, that works too.
Okay.
>
>> BTW, do you have further comment for other patches in this series? Only
>> few minor updates since v4 patches and would like to get it into the
>> v3.18 merge window if possible. What's your opinion?
>
> The 3.18 merge window is closed, we already have 3.18-rc2 now.
>
> I have taken another look over the series now, I only had
> a few additional comments. Please fix those along with the comments
> you got from other reviewers and then ask Stephen Rothwell to
> include your tree in linux-next (if it isn't already).
Okay, I will fix them and will ask Stephen to include nios2 tree later.
Anyone other thing I need to do other than this? Do we need setup
nios2 repo in git://git.kernel.org? Or can we use our own git repo?

>
> When 3.18 is released, you can then send a pull request to Linus.
Okay, will wait for 3.18 to release then.

Thanks for reviewing.

Regards
Ley Foon
