Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaLATEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:04:04 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:61076 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaLATEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:04:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAN+gG=GZXNABPzFA=ivfoJDzd-=2X7t7FoQDGfo6g1b4bfwihA@mail.gmail.com>
References: <1417100556-7096-1-git-send-email-mathieu.magnaudet@enac.fr>
	<CAN+gG=GZXNABPzFA=ivfoJDzd-=2X7t7FoQDGfo6g1b4bfwihA@mail.gmail.com>
Date: Mon, 1 Dec 2014 20:04:01 +0100
Message-ID: <CANq1E4TJGJ0rx1L3iXiNRPbcy3NZ=ZOiGXzHRjKUfgsiTk+S1g@mail.gmail.com>
Subject: Re: [PATCH] hid: export hid_report_len as an inline function in hid.h
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Mathieu Magnaudet <mathieu.magnaudet@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Dec 1, 2014 at 7:22 PM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> On Thu, Nov 27, 2014 at 10:02 AM, Mathieu Magnaudet
> <mathieu.magnaudet@gmail.com> wrote:
>> in several hid drivers it is necessary to calculate the length
>> of an hid_report. This patch exports the existing static function
>> hid_report_len of hid-core.c as an inline function in hid.h
>>
>> Signed-off-by: Mathieu Magnaudet <mathieu.magnaudet@enac.fr>
>> ---
>
> IIRC, there are a few more custom report length computations
> throughout the HID tree. They are not straightforward to convert, so I
> think we have a pretty good start here.
>
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>

I fully agree!

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David
