Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaLTQC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:02:28 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:50770 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaLTQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:02:25 -0500
MIME-Version: 1.0
In-Reply-To: <20141220000920.13943.50943.stgit@notabene.brown>
References: <20141219235827.13943.45713.stgit@notabene.brown> <20141220000920.13943.50943.stgit@notabene.brown>
From: Christ van Willegen <cvwillegen@gmail.com>
Date: Sat, 20 Dec 2014 17:02:04 +0100
Message-ID: <CA+Ot1Own-g=vjYhOygzVgNPspw6FgCHZqY8wQo31=ahf62E1gA@mail.gmail.com>
Subject: Re: [Gta04-owner] [PATCH 2/2] misc: add a driver to power on/off UART
 attached devices.
To: List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Reichel <sre@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Jiri Slaby <jslaby@suse.cz>,
        NeilBrown <neil@brown.name>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One remark:

+config SERIAL_POWER_MANAGER
+       tristate "Power Management controller for serial-attached devices"
+       depends on TTY && OF
+       default n
+       help
+         Some devices permanently attached via a UART can benefit from
+         being power-managed when the tty device is openned or closed.
+         This driver can support several such devices with simple
+         power requirements such as enabling a regulator.
+
+         If in doubt, say 'N'
+

There's a typo: openned.

Christ van Willegen
