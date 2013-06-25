Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3FYG72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:59:28 -0400
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:44837 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113Ab3FYG71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:59:27 -0400
Message-ID: <51C93E7B.30709@st.com>
Date: Tue, 25 Jun 2013 07:53:47 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Rob Landley <rob@landley.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/7] ARM:STixxxx: Add STixxxx platform and board support
References: <1371811076-27168-1-git-send-email-srinivas.kandagatla@st.com> <20130624175415.GA31429@quad.lixom.net>
In-Reply-To: <20130624175415.GA31429@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/13 18:54, Olof Johansson wrote:
> On Fri, Jun 21, 2013 at 11:37:56AM +0100, Srinivas KANDAGATLA wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> Thankyou all for reviewing the v3 patches.
>>
>> This patch-set adds basic support for STMicroelectronics STixxxx SOCs
>> which includes STiH415 and STiH416 with B2000 and B2020 board support.
>>
>> STiH415 and STiH416 are dual-core ARM Cortex-A9 CPU, designed for use in
>> Set-top-boxes. The SOC support is available in mach-stixxxx which contains
>> support code for STiH415, STiH416 SOCs including the generic board support.
>>
>> The reason for adding two SOCs at this patch set is to show that no new
>> C code is required for second SOC(STiH416) support.
>>
>> This patch-set only contains the SOC support, all the driver support for
>> this platform are submitted to respective mailing lists.
> 
> Hi,
> 
> I think these are looking quite reasonable, and I am ready to apply them
> to 3.11.
> 
> However, I have one bikeshed comment. I find the name of the platform to be
> awkward. Would you mind naming it mach-sti instead?
Am OK to rename them,
But, I see the patches on arm-soc for-next branch.

Thanks,
srini


> 
> 
> -Olof
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

