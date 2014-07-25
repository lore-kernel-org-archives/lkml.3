Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320AbaGYMnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:43:12 -0400
Received: from si-002-i54.relay.mailchannels.net ([184.154.112.228]:8128 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751642AbaGYMmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:42:55 -0400
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-MC-Relay: Good
X-MailChannels-SenderId: arvixe|x-authuser|przemo@firszt.eu
X-MailChannels-Auth-Id: arvixe
Message-ID: <1406292140.2664.17.camel@fedora-lan>
Subject: Re: [PATCH v2 00/10] Input - wacom: conversion to HID driver,
 series 2
From: Przemo Firszt <przemo@firszt.eu>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Date: Fri, 25 Jul 2014 13:42:20 +0100
In-Reply-To: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AuthUser: przemo@firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2014-07-24, czw o godzinie 14:13 -0400, Benjamin Tissoires pisze:
[..]
> Hi Przemo,
Hi Benjamin,
> Normally, this series contains all the bits of hid-wacom (except the custom
> LED/OLED API). Please tell me if I am missing anything and if you like the
> change.

I can't cleanly apply your set yet to test it, so:

Acked-by: Przemo Firszt <przemo@firszt.eu>

What's your plan about LED/OLED API? 

> Benjamin Tissoires (9):
>   Input - wacom: put a flag when the led are initialized
>   Input - wacom: enhance Wireless Receiver battery reporting
>   Input - wacom: use a uniq name for the battery device
>   Input - wacom: register an ac power supply for wireless devices
>   Input - wacom: prepare the driver to include BT devices
>   Input - wacom: handle Graphire BT tablets in wacom.ko
>   Input - wacom: handle Intuos 4 BT in wacom.ko
>   Input - wacom: add copyright note and bump version to 2.0
>   HID: remove hid-wacom Bluetooth driver
> 
> Jason Gerecke (1):
>   Input - wacom: Support up to 2048 pressure levels with ISDv4
> 
>  drivers/hid/Kconfig     |  10 +-
>  drivers/hid/Makefile    |   3 +-
>  drivers/hid/hid-core.c  |   2 -
>  drivers/hid/hid-wacom.c | 973 ------------------------------------------------
>  drivers/hid/wacom.h     |  11 +
>  drivers/hid/wacom_sys.c | 217 ++++++++++-
>  drivers/hid/wacom_wac.c | 195 +++++++++-
>  drivers/hid/wacom_wac.h |  10 +
>  8 files changed, 415 insertions(+), 1006 deletions(-)
>  delete mode 100644 drivers/hid/hid-wacom.c
> 

-- 
Kind regards,
Przemo Firszt


