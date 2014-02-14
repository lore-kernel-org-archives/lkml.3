Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaBNTbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:31:23 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:49615 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaBNTbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:31:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140214192322.GJ30257@n2100.arm.linux.org.uk>
References: <20140213195230.GA15275@www.outflux.net>
	<20140214101724.GC10590@arm.com>
	<CAGXu5jKYq=0Ud-A6bdD2zMe=+r0S7nja8Rg+OxeT+JHzdpwTKg@mail.gmail.com>
	<20140214192322.GJ30257@n2100.arm.linux.org.uk>
Date: Fri, 14 Feb 2014 11:31:21 -0800
X-Google-Sender-Auth: EdOs1EdR78r7eUa_HXUKRLi-hy0
Message-ID: <CAGXu5jK6Ro+u1VBsnQvNMZz4+iUZPLSRsd98oBgXCQAx=vW2YA@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: mm: report both sections from PMD
From: Kees Cook <keescook@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:23 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>> https://lkml.org/lkml/2014/2/12/662
>
> It's not that simple, because APX in section descriptors doesn't exist
> on pre-v6 ARMs.  This needs to be conditional upon the CPU arch.

Ah! Okay, do we need a single #define to describe the expected masks
and values? What should it look like for pre-v6 ARMs?

-Kees

-- 
Kees Cook
Chrome OS Security
