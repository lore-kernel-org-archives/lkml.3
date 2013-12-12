Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3LLMpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:45:50 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:38808 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3LLMps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:45:48 -0500
Message-ID: <52A9AFFD.1040408@cogentembedded.com>
Date: Thu, 12 Dec 2013 16:45:49 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>
CC: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@adurom.com>,
        Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting permanent
 mac address
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>		 <201312101814.35112@pali> <1386697762.30202.6.camel@dcbw.foobar.com>		 <201312101852.17030@pali>	 <1386796654.1516.268.camel@bwh-desktop.uk.level5networks.com>	 <52A8DA9A.50501@gmail.com> <1386800135.1516.296.camel@bwh-desktop.uk.level5networks.com> <52A8E8EE.7050001@gmail.com>
In-Reply-To: <52A8E8EE.7050001@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-12-2013 2:36, Ivajlo Dimitrov wrote:

>> 2. NVRAM reading is done by a tiny driver that is loaded based on the
>> platform name and updates the DT node in memory.  (But I don't know how
>> wl1251 should decide to defer probing if it's probed before that other
>> driver.)

>> Ben.


> Maybe a "hwmac" property with a value of XX:XX:XX:XX:XX:XX (or some other
> invalid value) set in DT could be used to tell the driver to defer until that
> value changes to something sane?

    The standard property name for that is "local-mac-address". There's also 
non-standard "mac-address" variation.

> Ivo

WBR, Sergei

