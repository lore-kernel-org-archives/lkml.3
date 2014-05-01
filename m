Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaEARgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:36:48 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36584 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaEARgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:36:46 -0400
Message-ID: <53628627.2020401@gmail.com>
Date: Thu, 01 May 2014 19:36:39 +0200
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: Re: [PATCH v3 1/9] mtd: nand: define struct nand_timings
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com> <1394647664-8258-2-git-send-email-b.brezillon.dev@gmail.com> <20140430175157.GB2497@norris-Latitude-E6410>
In-Reply-To: <20140430175157.GB2497@norris-Latitude-E6410>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On 30/04/2014 19:51, Brian Norris wrote:
> Hi Boris,
>
> On Wed, Mar 12, 2014 at 07:07:36PM +0100, Boris BREZILLON wrote:
>> +
>> +/**
>> + * struct nand_sdr_timings - SDR NAND chip timings
>> + *
>> + * This struct defines the timing requirements of a SDR NAND chip.
>> + * These informations can be found in every NAND datasheets and the timings
>> + * meaning are described in the ONFI specifications:
>> + * www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf‎ (chapter 4.15 Timing
> Can you remove the unicode U+200E character?

Sure

>
>> + * Parameters)
> Please document the units for these fields here. It looks like you're
> using picoseconds.

I'll add field units (which are indeed picoseconds) to this comment.

Best Regards,

Boris
