Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3GWHej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:34:39 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:32817 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722Ab3GWHeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:34:37 -0400
Message-ID: <51EE2F73.9070600@st.com>
Date: Tue, 23 Jul 2013 08:23:31 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] ARM: STi: Set correct ARM ERRATAs.
References: <1373354752-26292-1-git-send-email-srinivas.kandagatla@st.com> <1373354793-26400-1-git-send-email-srinivas.kandagatla@st.com> <20130723023540.GA14983@quad.lixom.net>
In-Reply-To: <20130723023540.GA14983@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 23/07/13 03:35, Olof Johansson wrote:
> On Tue, Jul 09, 2013 at 08:26:33AM +0100, Srinivas KANDAGATLA wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> Some of the ARM_ERRATA selection is not done in the initial SOC support
>> patches. This patch selects 2 new ARM_ERRATA's and removes one which was
>> actually fixed.
> 
> These entries should be sorted, and you inserted in random order.
Thanks Olof.
I will take a note of it.

> 
> I'll rearrange the order when applying.
> 
> (Patch applied with that change).
> 
> Thanks,
> 
> -Olof
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

