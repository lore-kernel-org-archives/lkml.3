Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3GIHNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:13:22 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:49067 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436Ab3GIHNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:13:19 -0400
Message-ID: <51DBB629.1050000@st.com>
Date: Tue, 09 Jul 2013 08:05:13 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v1 0/4] ARM: STi fixes and ethernet support
References: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com> <201307090118.06715.arnd@arndb.de>
In-Reply-To: <201307090118.06715.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Arnd,
On 09/07/13 00:18, Arnd Bergmann wrote:
> On Monday 08 July 2013, Srinivas KANDAGATLA wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> This patch series fixes 2 configuration issues and adds ethernet support to
>> STiH415, STiH416 based B2000, B2020 boards.
> 
> Hi Srini,
> 
> You really have to send those things separately, as the bug fixes should
> probably go into 3.11, while the rest is new features and needs to be
> reviewed for merging into 3.12.
Yes, I will resend the fixes separately.
> 
> I'm also puzzled by the fact that you add auxdata and callback
> functions for the ether part in the platform code. Those should
> probably all be properties added to the stmmac binding.

stmmac (aka "dwmac" a synopsis IP) driver is integrated in to kernel
sometime in 2.6 series I think :-), and Is used by more than 4 platforms
in 3.10 kernel. The driver is more generic than it sounds.
So adding properties/hooks specific to STiH41x SOCs in driver seemed to
incorrect. Instead doing platform specific bits in the mach via
callbacks was the only choice I had.

Thanks,
srini

> 
> 	Arnd
> 

