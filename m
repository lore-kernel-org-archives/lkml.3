Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3IMJyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:54:16 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:42861 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677Ab3IMJyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:54:06 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dominik Paulus <dominik.paulus@fau.de>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@i4.cs.fau.de,
        devel@driverdev.osuosl.org
Subject: [PATCHv2 0/11] staging: usbip: Userland crypto and ACLs
Date: Fri, 13 Sep 2013 11:55:50 +0200
Message-Id: <1379066161-8278-1-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
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

We've already sent this patch series, but forgot to specify a subject line.
linux-usb apparently received it[2], the LKML didn't. Sorry if you received it
twice now.

Regards,
	Tobias Polzer and Dominik Paulus

[1] See <6aeb926e1c4572e79488a91a827333c9.squirrel@faumail.uni-erlangen.de>
[2] http://www.mail-archive.com/linux-usb@vger.kernel.org/msg28689.html

