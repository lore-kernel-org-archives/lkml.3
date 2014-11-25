Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaKYQJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:09:19 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:61508 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaKYQJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:09:17 -0500
MIME-Version: 1.0
In-Reply-To: <5474A77B.10806@roeck-us.net>
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
	<1416930423-12179-3-git-send-email-bgolaszewski@baylibre.com>
	<5474A77B.10806@roeck-us.net>
Date: Tue, 25 Nov 2014 17:09:16 +0100
Message-ID: <CAMpxmJXA_jKgxb64EMK3KjxSDbTdi2x4rN0FTcVieOLMLCvZSg@mail.gmail.com>
Subject: Re: [PATCH 2/5] hwmon: ina2xx: make shunt resistance configurable at run-time
From: =?UTF-8?Q?Bartosz_Go=C5=82aszewski?= <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-25 16:59 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> For a given system it should always be known, and it appears unlikely
> that there is a system out there where the shunt resistor value can change.
>
> What system exactly are you talking about ?

We're talking about the ACME cape for BeagleBone Black:
http://baylibre.com/acme/

The probes you can see on the page can be connected in various
configurations and different probes have different shunt resistors.
Their values are set from the user-space after booting, hence the
patch.

Bart
