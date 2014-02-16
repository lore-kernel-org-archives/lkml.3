Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116AbaBPGiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 01:38:25 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:50807 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaBPGiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 01:38:24 -0500
MIME-Version: 1.0
In-Reply-To: <20140215191645.GF1801@kroah.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
	<1392488822-18178-1-git-send-email-jaswinder.singh@linaro.org>
	<20140215191645.GF1801@kroah.com>
Date: Sun, 16 Feb 2014 12:08:23 +0530
Message-ID: <CABb+yY1A1JwHdmzLTuuWyMG0Li61CYyUg=9aaNLeGZP6ME9kYg@mail.gmail.com>
Subject: Re: [PATCHv3 6/6] mailbox: move the internal definitions into a
 private file
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>, courtney.cavin@sonymobile.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 12:46 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Feb 15, 2014 at 11:57:02PM +0530, Jassi Brar wrote:
>> From: Suman Anna <s-anna@ti.com>
>>
>> This is needed for extracting the omap_mbox. The OMAP mailbox
>> code has a need for exporting some pre-existing API to not
>> break the current clients.
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> ---
>>  drivers/mailbox/mailbox.c          | 62 +-----------------------------
>>  drivers/mailbox/mailbox_internal.h | 77 ++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 78 insertions(+), 61 deletions(-)
>>  create mode 100644 drivers/mailbox/mailbox_internal.h
>
> Also, this patch doesn't seem to be needed at all here, nothing breaks
> without it, so why include it in this series?
>
Suman had to segregate the definitions temporarily while the TI
drivers were sorted out. I hope Suman says the patch isn't needed
anymore :)

Thanks,
Jassi
