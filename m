Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3LNIch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 03:32:37 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38726 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3LNIcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 03:32:36 -0500
MIME-Version: 1.0
In-Reply-To: <20131213190707.GA9713@roeck-us.net>
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com>
	<1386945188-8316-2-git-send-email-jonas.jensen@gmail.com>
	<201312131717.25435.arnd@arndb.de>
	<CACmBeS0Uz+Z=MsqvXburO1swCdyGvEXHhfs8M7ZnMMKBNJjG1A@mail.gmail.com>
	<20131213190707.GA9713@roeck-us.net>
Date: Sat, 14 Dec 2013 09:32:36 +0100
Message-ID: <CACmBeS2_WZj6_HJo0N50TBwneNVmeB9TyXbHRLm9CJFGNN+HtQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 December 2013 20:07, Guenter Roeck <linux@roeck-us.net> wrote:
>> I got the impression from Guenter Roeck's review, that it doesn't belong there,
>> maybe I was too quick to remove it?
>>
> You'd have to answer the questions I raised in my review if you want it in
> there.

I didn't see a solution at the time. Now I'm thinking arm_pm_restart
can be set later in probe, preventing a crash on load failure, and
maybe it can be unset on unload.

Would you accept a patch for this?

Best regards,
Jonas
