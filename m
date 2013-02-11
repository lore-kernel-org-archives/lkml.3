Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3BKLUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:20:32 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:44239 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3BKLUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:20:30 -0500
MIME-Version: 1.0
In-Reply-To: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 11 Feb 2013 12:20:28 +0100
Message-ID: <CAN+gG=GcmwAXLR-eADh=v1BsqvaXTDG_UJfT-5dggiLFx0moSg@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: extend autodetect to handle I2C sensors as well
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, srinivas.pandruvada@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 11:31 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Since the advent of HID over I2C protocol, it is possible to have sensor
> hubs behind I2C bus as well. We can autodetect this in a same way than USB
> sensor hubs.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin
