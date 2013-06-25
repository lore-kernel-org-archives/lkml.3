Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3FYUrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:47:24 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:57319 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3FYUrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:47:19 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130625203002.GA15068@quad.lixom.net>
References: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com>
	<20130625203002.GA15068@quad.lixom.net>
Date: Tue, 25 Jun 2013 13:47:16 -0700
Message-ID: <CAOesGMhsaGcpW80CjBRtwVjJLOaRj8yTa6xFz_gjG1WPqTAKLQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] ARM:sti: Add STiH415/STiH416 platform and board support
From: Olof Johansson <olof@lixom.net>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 1:30 PM, Olof Johansson <olof@lixom.net> wrote:
> On Tue, Jun 25, 2013 at 12:13:42PM +0100, Srinivas KANDAGATLA wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> This patch-set adds basic support for STMicroelectronics STi series SOCs
>> which includes STiH415 and STiH416 with B2000 and B2020 board support.
>>
>> STiH415 and STiH416 are dual-core ARM Cortex-A9 CPU, designed for use in
>> Set-top-boxes. The SOC support is available in mach-sti which contains
>> support code for STiH415, STiH416 SOCs including the generic board support.
>>
>> The reason for adding two SOCs at this patch set is to show that no new
>> C code is required for second SOC(STiH416) support.
>>
>> This patch-set only contains the SOC support, all the driver support for
>> this platform are submitted to respective mailing lists.
>>
>> Changes since v4:
>>       - Renamed mach-stixxxx to mach-sti as suggested by Olof J.
>
> Thanks!
>
> I've merged this into next/late, and I'll drop the previous test merge by Arnd
> of the last version of the patch set.

I noticed that the defconfig update contained new drivers/options that
won't make it into 3.11. So to avoid churn, I dropped those. We'll do
a patch to enable all new platforms and drivers towards the end of the
merge window and apply on top of next/late, I think, so it should be
taken care of by that.

The rest of the code from the series is in though.

-Olof
