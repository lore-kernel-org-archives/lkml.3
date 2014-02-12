Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaBLVf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:35:57 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49131 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaBLVfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:35:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140212174554.GM27395@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
	<201402121251.06280.arnd@arndb.de>
	<20140212174554.GM27395@titan.lakedaemon.net>
Date: Wed, 12 Feb 2014 13:35:54 -0800
X-Google-Sender-Auth: I3vOzn9z7snq0AiS2MeZ5lzEzDQ
Message-ID: <CAGXu5j+BQzrgoAN-TiCaaoQaEjB+JQOCZLKq+_rFoWdFR-UpqQ@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
From: Kees Cook <keescook@chromium.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Laura Abbott <lauraa@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 9:45 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> I brought this up at last weeks devicetree irc meeting.  My goal is to
> provide early randomness for kaslr on ARM.  Currently, my idea is modify
> the init script to save an additional random seed from /dev/urandom to
> /boot/random-seed.

I'm all for a good entropy source for early boot. :)

I need to figure out what's needed for relocation support first
though, before we can really tackle kernel base-address randomization
on ARM. I haven't had a chance to look around too closely yet, but it
seems like only x86 and ppc do this currently? Has anyone looked in
detail and what would be needed on ARM for CONFIG_RELOCATABLE
behavior?

-Kees

-- 
Kees Cook
Chrome OS Security
