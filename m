Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab3GXLcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 07:32:32 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:40359 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3GXLcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 07:32:31 -0400
MIME-Version: 1.0
In-Reply-To: <24129555.GbVZ9SDS5Q@vostro.rjw.lan>
References: <CADDKRnBRyJZCoy3G53b6tY7J21XZp5bGn7nJi87WUgEGhSuT_w@mail.gmail.com>
	<24129555.GbVZ9SDS5Q@vostro.rjw.lan>
Date: Wed, 24 Jul 2013 13:32:31 +0200
Message-ID: <CADDKRnDDdJrTxWGySAnXs-rA+aq4zmH1+eA8xrdVGdW+vL8_SQ@mail.gmail.com>
Subject: Re: [v3.11-rc2] regression: brightness always on maximum.
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rafael.j.wysocki@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/24 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday, July 23, 2013 09:52:15 AM Jörg Otte wrote:
>> The brightness of my laptop is always on maximum and can't be scaled
>> down.
>> Brightness control via function keys was always working on this
>> laptop, so this is a regression in v3.11-rc2.
>
> Is there any other way to control brightness on your system (eg. through a GUI)?
Yes

> If so, does it work?
No, it has no visible effect.

> Also, does reverting commit efaa14c help?
No

>  If it doesn't help, does reverting
> commit 8c5bd7a too (so that both are reverted) help?
Yes, reverting both fixes the problem for me.

Thanks, Jörg
