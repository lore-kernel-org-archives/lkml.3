Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3AaRQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:16:41 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34073 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3AaRQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:16:39 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1301311758170.23853@pobox.suse.cz>
References: <1359651002-16562-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1301311758170.23853@pobox.suse.cz>
Date: Thu, 31 Jan 2013 18:16:37 +0100
Message-ID: <CAN+gG=GLhnvtJissAsk1WV5_O=RhLg1v5SBaF77F=oW_B01-BA@mail.gmail.com>
Subject: Re: [PATCH] HID: i2c-hid: fix i2c_hid_output_raw_report
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 5:58 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 31 Jan 2013, Benjamin Tissoires wrote:
>
>> i2c_hid_output_raw_report is used by hidraw to forward set_report requests.
>> The current implementation of i2c_hid_set_report needs to take the
>> report_id as an argument. The report_id is stored in the first byte
>> of the buffer in argument of i2c_hid_output_raw_report.
>>
>> Not removing the report_id from the given buffer adds this byte 2 times
>> in the command, leading to a non working command.
>>
>> Reported-by: Andrew Duggan <aduggan@synaptics.com>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>
> Applied, will push it for 3.8 still. Thanks,

Thanks Jiri!

Cheers,
Benjamin

>
> --
> Jiri Kosina
> SUSE Labs
