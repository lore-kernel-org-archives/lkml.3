Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3JGQJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:09:08 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:46327 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3JGQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:09:04 -0400
Message-ID: <5252DC9C.8090803@lwfinger.net>
Date: Mon, 07 Oct 2013 11:09:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arend van Spriel <arend@broadcom.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the wireless-next tree
References: <1381159127-11067-1-git-send-email-treding@nvidia.com>	 <1381159127-11067-5-git-send-email-treding@nvidia.com>	 <5252D7E4.2050509@lwfinger.net> <1381161393.2081.177.camel@joe-AO722>
In-Reply-To: <1381161393.2081.177.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 10:56 AM, Joe Perches wrote:
> On Mon, 2013-10-07 at 10:48 -0500, Larry Finger wrote:
>> On 10/07/2013 10:18 AM, Thierry Reding wrote:
>>> Today's linux-next merge of the wireless-next tree got conflicts in:
>>>
>>> 	drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
>>> 	drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
>>> 	drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
>>> 	drivers/net/wireless/rtlwifi/rtl8192de/phy.h
>>> 	drivers/net/wireless/rtlwifi/rtl8723ae/phy.h
> []
>> Yes, the patches for rtlwifi problems are correct. All of these problems would
>> have been avoided if changes to wireless drivers were sent to the wireless tree
>> rather than direct submission to net-next!!!!
>
> They were and you acked it.
> https://lkml.org/lkml/2013/9/25/589
>
> Who picks it up first and applies it is
> not in my domain.

Fair enough. I should have asked DaveM to let John apply those changes.

Larry


