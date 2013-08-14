Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab3HNVLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:11:34 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:57377 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186Ab3HNVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:11:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130814093836.57002b77@jbarnes-desktop>
References: <cover.1376494861.git.joseph.salisbury@canonical.com>
	<d4635f76028172e872cc4be506bad1c11816f75a.1376494861.git.joseph.salisbury@canonical.com>
	<20130814093836.57002b77@jbarnes-desktop>
Date: Wed, 14 Aug 2013 14:11:31 -0700
X-Google-Sender-Auth: M7vwHn24ygRc6FufGDzKQ40y5h8
Message-ID: <CA+55aFy09OfUb_ENi6NgVWaNM7YBvLovcf5FvyHfpXXBUGsQkg@mail.gmail.com>
Subject: Re: [PATCH 1/1] intel_ips: blacklist ASUSTek G60JX laptops
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        platform-driver-x86@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 9:38 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Linus, you may want to pick this up directly, as I'm not sure if
> Matthew is still looking after the x86 drivers these days.

Can't we make the simpler patch be to just not spam the logs? Do it
once, and forget about it. Maybe make the timeouts long enough to make
sure that there are no other downsides from having the driver
occasionally testing if it's back?

I *detest* hardware-specific blacklists. They are impossible to
maintain, and we've had the situation more than once that we fixed the
real bug that caused the blacklist in the first place, but the entry
stays around because nobody knows/cares/tests it.

                  Linus
