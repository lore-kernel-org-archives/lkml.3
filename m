Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaLDK4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:56:04 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:62935 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaLDK4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:56:02 -0500
MIME-Version: 1.0
Reply-To: rogelio.serrano@gmail.com
In-Reply-To: <CAB_-8bJhZjZp+1KDYOSaFQa3fcDt+hhHywDP4CUWZEr4_PQKUQ@mail.gmail.com>
References: <CAB_-8bJhZjZp+1KDYOSaFQa3fcDt+hhHywDP4CUWZEr4_PQKUQ@mail.gmail.com>
Date: Thu, 4 Dec 2014 10:56:00 +0000
Message-ID: <CAB_-8bL+QoXz2OuZgb7iyxYFwoWiTrZdexESfsf4AJYoObbcaA@mail.gmail.com>
Subject: Fwd: direct firmware load failure with loadable kernel modules and
 userspace firmware loader user helper fallback turned off
From: "Rogelio M. Serrano Jr." <rogelios664@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Rogelio M. Serrano Jr. <rogelios664@gmail.com>
Date: Thu, Dec 4, 2014 at 10:48 AM
Subject: direct firmware load failure with loadable kernel modules and
userspace firmware loader user helper fallback turned off
To: linux-kernel@vger.kernel.org





Dec  3 10:18:02 (none) klogd: [    1.789031] iwl4965: Intel(R)
Wireless WiFi 4965 driver for Linux, in-tree:
Dec  3 10:18:02 (none) klogd: [    1.790767] iwl4965: Copyright(c)
2003-2011 Intel Corporation
Dec  3 10:18:02 (none) klogd: [    1.792484] iwl4965 0000:03:00.0:
can't disable ASPM; OS doesn't have ASPM control
Dec  3 10:18:02 (none) klogd: [    1.794421] iwl4965 0000:03:00.0:
Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
Dec  3 10:18:02 (none) klogd: [    1.839823] iwl4965 0000:03:00.0:
device EEPROM VER=0x36, CALIB=0x5
Dec  3 10:18:02 (none) klogd: [    1.841597] iwl4965 0000:03:00.0:
Tunable channels: 11 802.11bg, 13 802.11a channels
Dec  3 10:18:02 (none) klogd: [    1.843495] iwl4965 0000:03:00.0: irq
31 for MSI/MSI-X
Dec  3 10:18:02 (none) klogd: [    1.843839] iwl4965 0000:03:00.0:
Direct firmware load for iwlwifi-4965-2.ucode failed with error -2
Dec  3 10:18:02 (none) klogd: [    1.845598] iwl4965 0000:03:00.0:
request for firmware file 'iwlwifi-4965-2.ucode' failed.
Dec  3 10:18:02 (none) klogd: [    1.847392] iwl4965 0000:03:00.0: no
suitable firmware found!


turning loadable modules back on works.
