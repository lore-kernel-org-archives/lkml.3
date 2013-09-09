Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3IIQiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:38:25 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42418 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3IIQiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:38:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-2HqXVR5rFCa0XGmFpJcPWgPBKKaELgmFxhWKxxOYQRc-m2A@mail.gmail.com>
References: <CAG-2HqXVR5rFCa0XGmFpJcPWgPBKKaELgmFxhWKxxOYQRc-m2A@mail.gmail.com>
Date: Mon, 9 Sep 2013 18:38:23 +0200
Message-ID: <CANq1E4QNE7v1fV71E8EwPiKRR1A63erVKVYO07mJ0ySD+etG6g@mail.gmail.com>
Subject: Re: [BUG?] HID: uhid: add devname module alias
From: David Herrmann <dh.herrmann@gmail.com>
To: Tom Gundersen <teg@jklm.no>
Cc: Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
        Kay Sievers <kay@vrfy.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom

On Mon, Sep 9, 2013 at 5:43 PM, Tom Gundersen <teg@jklm.no> wrote:
> Hi Marcel,
>
> The above commit (60cbd53 in mainline) doesn't appear to work for me.
> I.e., depmod does not create an entry in modules.devname and hence no
> device node is created on boot.
>
> If I understand correctly, you'd also need to create the correct
> "char-major-<MAJOR>-<MINOR>" alias (which I don't think you can do as
> long as you are using MISC_DYNAMIC_MINOR).
>
> Or am I missing something?

Nope, that's correct as discussed on IRC. Patch pending as:
  Subject: [PATCH] HID: uhid: allocate static minor
  Message-Id: <1378744434-10883-1-git-send-email-dh.herrmann@gmail.com>

Thanks
David
