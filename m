Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbbALAmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 19:42:18 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55919 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbALAmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 19:42:15 -0500
From: Julian Brost <julian@0x4a42.net>
X-Google-Original-From: Julian Brost <linux-kernel@0x4a42.net>
Message-ID: <54B31863.6050403@0x4a42.net>
Date: Mon, 12 Jan 2015 01:42:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-mei-owner@linux.intel.com
CC: Jonathan Corbet <corbet@lwn.net>, Tomas Winkler <tomas.winkler@intel.com>,
        linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julian Brost <linux-kernel@0x4a42.net>,
        Fabian Hofmann <fabian.hofmann@fau.de>, linux-kernel@i4.cs.fau.de
Subject: Use of the address linux-mei@linux.intel.com in the Linux kernel
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the e-mail address linux-mei@linux.intel.com is given as contact address
in multiple files in the Linux kernel [1]. Earlier today I cc'd a patch
to this address [2] which got rejected since I'm not a list member.
Subscribing to it doesn't seem to be possible either.

Therefore this address seems inappropriate as a contact address. In my
opinion either sending mail there should be allowed or the address might
be replaced with another one (I don't know any) or removed completely,
but at the moment it's pretty useless.

Regards,das
Julian

[1] Documentation/ABI/testing/sysfs-bus-mei
    Documentation/misc-devices/mei/mei-amt-version.c
    Documentation/misc-devices/mei/mei.txt
    drivers/misc/mei/hw-me-regs.h
    drivers/misc/mei/hw-txe-regs.h
    include/uapi/linux/mei.h
[2] 1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net
    https://lkml.org/lkml/2015/1/11/282
