Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab3AaDwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 22:52:34 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:41686 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab3AaDwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 22:52:31 -0500
MIME-Version: 1.0
In-Reply-To: <11530988.U26HMGnFLa@vostro.rjw.lan>
References: <2099093.cPXO6Nhn9v@netbook>
	<50F2C79E.5000302@linaro.org>
	<11530988.U26HMGnFLa@vostro.rjw.lan>
Date: Wed, 30 Jan 2013 19:52:30 -0800
X-Google-Sender-Auth: XUaE0HqMaalGMuOCPxr8wMEKn14
Message-ID: <CAODwPW9-dNRpKhhskbxU7Cva_1Y_dfCEN6cKt7pviWdeXoW7eg@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: fix new C-states not functional after AC disconnect
From: Julius Werner <jwerner@chromium.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Schlichter <thomas.schlichter@web.de>,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        =?ISO-8859-1?Q?Andreas_M=FCller?= <goo@stapelspeicher.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Rafael, is possible to apply the patch [1/2] I previously sent ?
>>
>> https://patchwork.kernel.org/patch/1878691/
>
> I need to talk about this with Len.  That should happen tomorrow if everything
> goes well.

Hi Rafael,

Have you made a decision on picking up Daniel's first change yet? I
think it really is the cleanest way to solve this problem.
