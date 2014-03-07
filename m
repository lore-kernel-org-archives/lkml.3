Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaCGJwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:52:09 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41760 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaCGJwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:52:04 -0500
MIME-Version: 1.0
In-Reply-To: <1394054334-20438-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1394054334-20438-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Fri, 7 Mar 2014 10:52:02 +0100
Message-ID: <CANq1E4QRc+cwAJYFJg2F8WpSOrx2xXuPeiZYF6np_2C5CoqRqA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] HID: ll transport cleanup: final round
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        David Barksdale <dbarksdale@uplogix.com>, Antonio Ospite <ao2@ao2.it>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Mar 5, 2014 at 10:18 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Alright, this is the re-spin of the last round of transport cleanup.
>
> Some minor but important modifications are here, but nothing very enthousiastic.
>
> Thanks for the reviews and the tests so far.

Apart from some minor comments on #1 and #2, this is:

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> Cheers,
> Benjamin
>
> Benjamin Tissoires (4):
>   HID: cp2112: remove various hid_out_raw_report calls
>   HID: cp2112: remove the last hid_output_raw_report() call
>   HID: sony: do not rely on hid_output_raw_report
>   HID: remove hid_output_raw_report transport implementations
>
>  drivers/hid/hid-cp2112.c      | 19 +++++++++-----
>  drivers/hid/hid-sony.c        | 60 ++++++++++---------------------------------
>  drivers/hid/hidraw.c          |  3 ++-
>  drivers/hid/i2c-hid/i2c-hid.c | 14 ----------
>  drivers/hid/uhid.c            |  1 -
>  drivers/hid/usbhid/hid-core.c | 19 +++++---------
>  include/linux/hid.h           | 21 ++-------------
>  net/bluetooth/hidp/core.c     | 14 ----------
>  8 files changed, 36 insertions(+), 115 deletions(-)
>
> --
> 1.8.5.3
