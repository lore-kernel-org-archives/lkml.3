Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3IKQEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:04:46 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:44454 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754840Ab3IKQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:04:44 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: linux-kernel@vger.kernel.org
Cc: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Dominik Paulus <dominik.paulus@fau.de>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@i4.cs.fau.de, devel@driverdev.osuosl.org
Subject: 
Date: Wed, 11 Sep 2013 18:06:46 +0200
Message-Id: <1378915617-29791-1-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378732471-5967-1-git-send-email-dominik.paulus@fau.de>
References: <1378732471-5967-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series includes an updated version of the IPv6 support patch (a call
to freeaddrinfo() was missing) as well as:

 - The client/server authentication support using GnuTLS Tobias already
   announced on the usbip-devel mailing list some time ago[1]

 - Support for restricting the access to devices to specific IP address ranges

 - Improved error reporting and new error codes to be passed over the TCP
   protocol.

We think that the added features justify a version bump to 1.2.0. The
corresponding patch is also included. All protocol changes are
backwards-compatible, thus, we don't increment the protocol version.

Regards,
	Tobias Polzer and Dominik Paulus

[1] See <6aeb926e1c4572e79488a91a827333c9.squirrel@faumail.uni-erlangen.de>

