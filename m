Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbaIBESY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 00:18:24 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62794 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaIBESX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 00:18:23 -0400
Message-ID: <54054509.2070609@gmail.com>
Date: Tue, 02 Sep 2014 12:18:17 +0800
From: Chunwei Chen <tuxoko@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: [uas/3.16.1] panic in uas_data_cmplt()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all:

The kernel version is 3.16.1-1-ARCH

Today I keep getting this panic when booting up.
http://i.imgur.com/0Rx93Kr.jpg

It might be that the UAS device was in some strange state,
because that after I unplugged and power-cycled the UAS,
everything went normal again.

Does anyone know what's the root cause of this issue?
Or could anyone provide some instruction on how to debug this issue?

Thanks
