Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3HVIh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:37:29 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:57738 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3HVIh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:37:26 -0400
MIME-Version: 1.0
In-Reply-To: <52153015.6060409@linux.intel.com>
References: <1377099620-23947-1-git-send-email-benjamin.tissoires@redhat.com>
	<52153015.6060409@linux.intel.com>
Date: Thu, 22 Aug 2013 10:37:23 +0200
Message-ID: <CAN+gG=GOSumLQgeZNnZJg2b4pV9c9O4C5E6SxvtFaLpiLmeYSw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] HID: Win 8 multitouch panels detection in core
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:24 PM, Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
> On 08/21/2013 08:40 AM, Benjamin Tissoires wrote:
>>
>> Hi guys,
>>
>> this is the v2 of the rework of the pre-scanning of the hid report
>> descriptors.
>> This allows us to be able to detect Win 8 multitouch panels.
>> I tried to take into account all of the previous reviews, and I think the
>> patch
>> series is in a better shape now.
>>
>> Alexander, Srinivas, could you please review/test patches 1/3 and 2/3 as
>> they
>> will both impact hid_sensor_hub detection now. From the report descriptors
>> Alexander sent, I would say that it will work now, but it's always better
>> to
>> have different testers :)
>
> Tested sensor hub. It works.

Thanks for the test Srinivas :)

Cheers,
Benjamin
