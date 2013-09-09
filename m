Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3IIPn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:43:26 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:62641 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3IIPnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:43:23 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 9 Sep 2013 17:43:02 +0200
Message-ID: <CAG-2HqXVR5rFCa0XGmFpJcPWgPBKKaELgmFxhWKxxOYQRc-m2A@mail.gmail.com>
Subject: [BUG?] HID: uhid: add devname module alias
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Kay Sievers <kay@vrfy.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

The above commit (60cbd53 in mainline) doesn't appear to work for me.
I.e., depmod does not create an entry in modules.devname and hence no
device node is created on boot.

If I understand correctly, you'd also need to create the correct
"char-major-<MAJOR>-<MINOR>" alias (which I don't think you can do as
long as you are using MISC_DYNAMIC_MINOR).

Or am I missing something?

Cheers,

Tom
