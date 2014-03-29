Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaC2Dzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 23:55:42 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:49981 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaC2Dzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 23:55:41 -0400
MIME-Version: 1.0
In-Reply-To: <1395960701-18725-1-git-send-email-markus.mayer@linaro.org>
References: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
	<1395960701-18725-1-git-send-email-markus.mayer@linaro.org>
Date: Sat, 29 Mar 2014 09:25:40 +0530
Message-ID: <CABb+yY0t-CbX5Fng-r=GpG6rsZ3268ZYP7w=8-75yz3eR0v8EA@mail.gmail.com>
Subject: Re: [PATCHv4 1/5] mailbox: rename pl320-ipc specific mailbox.h
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Suman Anna <s-anna@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 4:21 AM, Markus Mayer <markus.mayer@linaro.org> wrote:
>> The patch 30058677 "ARM / highbank: add support for pl320 IPC"
>> added a pl320 IPC specific header file as a generic mailbox.h.
>> This file has been renamed appropriately to allow the
>> introduction of the generic mailbox API framework.
>>
>> Acked-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>
>> ---
>> drivers/cpufreq/highbank-cpufreq.c |  2 +-
>>  drivers/mailbox/pl320-ipc.c        |  2 +-
>>  include/linux/mailbox.h            | 17 -----------------
>>  include/linux/pl320-ipc.h          | 17 +++++++++++++++++
>>  4 files changed, 19 insertions(+), 19 deletions(-)
>>  delete mode 100644 include/linux/mailbox.h
>>  create mode 100644 include/linux/pl320-ipc.h
>
> This does not look like GIT realized you were just renaming these files.
> When I apply this patch and re-generate the patch file, it looks like this:
>
> ...
>  drivers/cpufreq/highbank-cpufreq.c       |    2 +-
>  drivers/mailbox/pl320-ipc.c              |    2 +-
>  include/linux/{mailbox.h => pl320-ipc.h} |    0
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename include/linux/{mailbox.h => pl320-ipc.h} (100%)
> ...
>
OK, will generate the patch with -M option.

Thanks
Jassi
