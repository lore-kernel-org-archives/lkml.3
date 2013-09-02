Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab3IBPcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:32:10 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58425 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab3IBPcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:32:08 -0400
MIME-Version: 1.0
In-Reply-To: <5221F119.4070000@gmail.com>
References: <5221F119.4070000@gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 2 Sep 2013 16:31:48 +0100
X-Google-Sender-Auth: IWW00m_u6On0JX0li7so5z-uLVs
Message-ID: <CAHkRjk4g4-ig1zyX7qYO2byVhQQK0kZ4rgRCWU141hd-3c3==w@mail.gmail.com>
Subject: Re: 3.10.9: kmemleak disables all CPUs except CPU0
To: =?UTF-8?Q?Martin_MOKREJ=C5=A0?= <mmokrejs@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 August 2013 14:35, Martin MOKREJŠ <mmokrejs@gmail.com> wrote:
>   never realized that my CPUs are gone if I compile into kernel kmemleak.
> Is that really the aim?
>
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
>
> 1.  Why isn't there /sys/devices/system/cpu/cpu0/online file?
> Does not matter if it contains 0 or 1. It just should exist.

I can't really see how kmemleak would do this, maybe other config
options that get set/cleared in the process of selecting kmemleak. Can
you do a diff between your config with /sys/... entries and the one
without?

-- 
Catalin
