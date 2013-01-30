Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3A3IBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:01:07 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:47990 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3A3IBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:01:05 -0500
MIME-Version: 1.0
In-Reply-To: <1359531176.31148.46.camel@smile>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
	<20130129052247.GH2239@intel.com>
	<CAOh2x=nTJ1iz9aoR8VrkE5A+iaLMMbvFeebGPsO8KWRpDLw7=A@mail.gmail.com>
	<1359531176.31148.46.camel@smile>
Date: Wed, 30 Jan 2013 13:31:04 +0530
X-Google-Sender-Auth: euyJrwA-De46kDHU0v1g2e86OqI
Message-ID: <CAOh2x==Ng1=iHOj-55mUTWCwpaJpRXjiQyfxz-a48ALDOW3aiA@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line base
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 1:02 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> We get a device from the ACPI CSRT table. During enumeration we don't
> know what kind of the device it is. From the enumeration point of view
> each device enumerated from CSRT is a platform device (see
> drivers/acpi/csrt.c for the details).
>
> That's why we have to pass this info somehow to the DMAC driver. And
> like Mika already mentioned we have no other generic way except
> IORESOURCE_DMA. If you have something better in mind, please share. We
> could adopt our code then.

You don't need this in DT case too? Or only for ACPI case?

I think "Yes" is the answer of both the questions. If so, then you
can keep it this way or add another variable in platform data.
