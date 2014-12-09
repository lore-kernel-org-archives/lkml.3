Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbaLIAvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 19:51:23 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:64122 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbaLIAvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 19:51:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141209002911.GA3003@hudson.localdomain>
References: <1418081057-25283-1-git-send-email-george.mccollister@gmail.com>
	<20141209002911.GA3003@hudson.localdomain>
Date: Mon, 8 Dec 2014 18:51:20 -0600
Message-ID: <CAFSKS=O0amUJTHf2Pk_orfep9AF4mAqU4-gxzi5jqUBD7vThMg@mail.gmail.com>
Subject: Re: [PATCH] USB: serial: add nt124 usb to serial driver
From: George McCollister <george.mccollister@gmail.com>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        linux-usb@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review.

I didn't update the MAINTAINERS file because I looked in it and didn't
see any other individual usb/serial drivers listed with maintainers.

-George

On Mon, Dec 8, 2014 at 6:29 PM, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> George,
>
> On Mon, Dec 08, 2014 at 05:24:17PM -0600, George McCollister wrote:
>> This driver is for the NovaTech 124 4x serial expansion board for the
>> NovaTech OrionLXm.
>>
>> Firmware source code can be found here:
>> https://github.com/novatechweb/nt124
>>
>> Signed-off-by: George McCollister <george.mccollister@gmail.com>
>> ---
>>  drivers/usb/serial/Kconfig  |   9 +
>>  drivers/usb/serial/Makefile |   1 +
>>  drivers/usb/serial/nt124.c  | 429 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 439 insertions(+)
>>  create mode 100644 drivers/usb/serial/nt124.c
>>
>> diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
> [...]
>
> It applies to next without any errors, there are no checkpatch issues
> other than recommending updating the MAINTAINERS file, and I can't find
> any other obvious problems.  Looks good to me.
>
> Reviewed-by: Jeremiah Mahler <jmmahler@gmail.com>
>
> --
> - Jeremiah Mahler
