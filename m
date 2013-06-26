Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3FZJVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:21:12 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:52685 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379Ab3FZJVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:21:07 -0400
Message-ID: <51CAB11B.1070209@st.com>
Date: Wed, 26 Jun 2013 10:15:07 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Rob Landley <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 0/7] ARM:sti: Add STiH415/STiH416 platform and board
 support
References: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com> <20130625203002.GA15068@quad.lixom.net> <CAOesGMhsaGcpW80CjBRtwVjJLOaRj8yTa6xFz_gjG1WPqTAKLQ@mail.gmail.com>
In-Reply-To: <CAOesGMhsaGcpW80CjBRtwVjJLOaRj8yTa6xFz_gjG1WPqTAKLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 21:47, Olof Johansson wrote:
> On Tue, Jun 25, 2013 at 1:30 PM, Olof Johansson <olof@lixom.net> wrote:
>> On Tue, Jun 25, 2013 at 12:13:42PM +0100, Srinivas KANDAGATLA wrote:
>>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>>
>>> This patch-set adds basic support for STMicroelectronics STi series SOCs
>>> which includes STiH415 and STiH416 with B2000 and B2020 board support.
>>>
>>> STiH415 and STiH416 are dual-core ARM Cortex-A9 CPU, designed for use in
>>> Set-top-boxes. The SOC support is available in mach-sti which contains
>>> support code for STiH415, STiH416 SOCs including the generic board support.
>>>
>>> The reason for adding two SOCs at this patch set is to show that no new
>>> C code is required for second SOC(STiH416) support.
>>>
>>> This patch-set only contains the SOC support, all the driver support for
>>> this platform are submitted to respective mailing lists.
>>>
>>> Changes since v4:
>>>       - Renamed mach-stixxxx to mach-sti as suggested by Olof J.
>>
>> Thanks!
>>
>> I've merged this into next/late, and I'll drop the previous test merge by Arnd
>> of the last version of the patch set.
> 
Thanks Olof.
> I noticed that the defconfig update contained new drivers/options that
> won't make it into 3.11. So to avoid churn, I dropped those. We'll do
> a patch to enable all new platforms and drivers towards the end of the
> merge window and apply on top of next/late, I think, so it should be
> taken care of by that.
Ok..
> 
> The rest of the code from the series is in though.
> 
> -Olof
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 

