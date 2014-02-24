Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaBXKbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:31:48 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:53964 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaBXKbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:31:46 -0500
MIME-Version: 1.0
In-Reply-To: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392927890-2389-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Mon, 24 Feb 2014 11:31:46 +0100
Message-ID: <CANq1E4QNEuhUb8Lyd4XoWjdgj5CRaaPHsK1-t9if4bLv5EH54g@mail.gmail.com>
Subject: Re: [PATCH 0/3] HID: low level transport cleanup, series 3
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Feb 20, 2014 at 9:24 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Hi guys,
>
> this is a new round in the low level HID transport cleanup.
> These are the formely 7/14 an 12/14 only.
> I add in between a patch which makes .raw_request mandatory, to cleanup
> the old 12/14 (so 3/3 here).
>
> There is only two patches 2 merge after these 3... We are approaching the end!

All 3 look good:

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks again!
David

> Cheers,
> Benjamin
>
> Benjamin Tissoires (3):
>   HID: input: hid-input remove hid_output_raw_report call
>   HID: make .raw_request mandatory
>   HID: hidraw: replace hid_output_raw_report() calls by appropriates
>     ones
>
>  Documentation/hid/hid-transport.txt |  3 ++-
>  drivers/hid/hid-core.c              | 11 ++++++++---
>  drivers/hid/hid-input.c             | 10 ++++++----
>  drivers/hid/hidraw.c                | 19 ++++++++++++++-----
>  include/linux/hid.h                 |  5 +----
>  5 files changed, 31 insertions(+), 17 deletions(-)
>
> --
> 1.8.5.3
>
