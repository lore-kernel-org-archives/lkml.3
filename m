Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3JUOXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:23:30 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:55859 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3JUOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:23:27 -0400
MIME-Version: 1.0
In-Reply-To: <20131021065342.GW3521@intel.com>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
	<1382326010-4554-2-git-send-email-bleung@chromium.org>
	<20131021065342.GW3521@intel.com>
Date: Mon, 21 Oct 2013 07:23:26 -0700
X-Google-Sender-Auth: vEIRltCUeVXwZODTRSq63_uK8pE
Message-ID: <CANLzEksLZwFTkQ-=8xxYavrFqXiw7fi5VzpPumWR6WjPphbi8g@mail.gmail.com>
Subject: Re: [PATCH 1/2] i2c-designware-pci: Add Haswell ULT device IDs
From: Benson Leung <bleung@chromium.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: wsa@the-dreams.de, khali@linux-fr.org, andriy.shevchenko@linux.intel.com,
        jacmet@sunsite.dk, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Duncan Laurie <dlaurie@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 11:53 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
>> +     [haswell_0] = {
>> +             .bus_num     = -1,
>> +             .bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_STD,
>> +             .tx_fifo_depth = 32,
>> +             .rx_fifo_depth = 32,
>> +             .clk_khz      = 25000,
>
> The input clock for I2C in Haswell is 100MHz, not 25MHz.


Thanks for catching that. I will fix it.

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
