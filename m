Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3BKLVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:21:40 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:33670 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3BKLVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:21:39 -0500
MIME-Version: 1.0
In-Reply-To: <1360578679-7029-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com>
	<1360578679-7029-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 11 Feb 2013 12:21:37 +0100
Message-ID: <CAN+gG=EGK9nweX=1s1_g--xqapXhQu9+++GyZ=Jw=p=Q2Jz2_g@mail.gmail.com>
Subject: Re: [PATCH 2/3] HID: sensor-hub: get rid of unused
 sensor_hub_grabbed_usages[] table
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
> This table is not used anywhere in the driver so kill it.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---

Yep, it's rather strange that the compiler didn't complained...
Anyway, Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin
