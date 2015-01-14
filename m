Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbbANX0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:26:30 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39201 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbANX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:26:28 -0500
Message-ID: <1421277985.27643.22.camel@gmail.com>
Subject: samsung-laptop: enable better lid handling
From: Julijonas Kikutis <julijonas.kikutis@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Cc: Julijonas Kikutis <julijonas.kikutis@gmail.com>
Date: Wed, 14 Jan 2015 23:26:25 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I sent the patch <https://lkml.org/lkml/2014/12/11/414> to linux-kernel,
platform-driver-x86, and to the maintainer of samsung-laptop a month ago
and have not received any response. Any response would be welcome.

I have some additional thoughts about the patch. I don't know whether it
is a good idea to introduce a whitelist of laptops that the special
command applies to like I did, or would it be better to enable that
command for every laptop that reports having that command. I also
thought that maybe the maintainer of the module has some more Samsung
laptops to test.

Moreover, I was asked about the unavailability of this module which
exposes some abilities of the laptop otherwise missing (e.g. the battery
saving mode, SABI access for this lid handling issue, some LED
functionality for other laptops) in UEFI mode. Unfortunately, I could
not help about that. I see that he has asked about that himself
<https://lkml.org/lkml/2014/12/23/341> but got no reply. I would be also
interested in the state of this issue.

Thank you.

Julijonas

