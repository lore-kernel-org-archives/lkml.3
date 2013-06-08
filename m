Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3FHJIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 05:08:53 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:40494 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab3FHJIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 05:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <4247099.i8S79t0Pua@flatron>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<20130607205940.4816fed5@skate>
	<CAPweEDxtC+OamcpVEQ3BULbN88hSJzKoi0fkNLBAdZD04LQCNQ@mail.gmail.com>
	<4247099.i8S79t0Pua@flatron>
Date: Sat, 8 Jun 2013 10:08:50 +0100
Message-ID: <CAPweEDwON7x-FrqUrvKDNXu3nCYOgrEzY9V5q8zxvoe6kWKCtA@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel@lists.debian.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 9:28 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:

> Now that the discussion went off from "you stupid kernel developers

 *lol*.  i get that summary ["you said people were stupid!!!"] a lot.
i don't quite understand where it comes from, otherwise i would stop
doing it :)

> adopted DeviceTree without even asking a closed company about their
> proprietary solution, which does the same" to something a bit more
> constructive, let me point some of the benefits.

> [snip...]

 ahh, magic.  these have gone straight into that proposal.  i think
the best ones - the gems - are the test-coverage and formally allowing
public interaction.

 the test coverage because it will reduce the risk of errors in the
silicon [you never know when developing both hardware and software
where the bug might be] as well as reduce the development time and
development costs.

 the public interaction (which i was going to ask thomas and maxime
about, this morning) because it means a much faster feedback loop.

 i've been trying to think of ways to link "if you do X it will result
in more sales and reduce risk" to the discussion, and i think you
finally hit it tomasz, so thank you.

l.
