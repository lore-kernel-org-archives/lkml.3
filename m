Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3A1NoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 08:44:04 -0500
Received: from smtp191.dfw.emailsrvr.com ([67.192.241.191]:40628 "EHLO
	smtp191.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3A1NoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:44:00 -0500
Message-ID: <510680AD.2070908@calxeda.com>
Date: Mon, 28 Jan 2013 07:44:13 -0600
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/4 v11] arm highbank: add support for pl320 IPC
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1359143205-20279-1-git-send-email-mark.langsdorf@calxeda.com> <1359143205-20279-4-git-send-email-mark.langsdorf@calxeda.com> <1457500.uzVh9cxXhS@vostro.rjw.lan>
In-Reply-To: <1457500.uzVh9cxXhS@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 06:49 AM, Rafael J. Wysocki wrote:

>> +int pl320_ipc_register_notifier(struct notifier_block *nb)
>> +{
>> +	return atomic_notifier_chain_register(&ipc_notifier, nb);
>> +}
>> +EXPORT_SYMBOL(pl320_ipc_register_notifier);
>> +
>> +int pl320_ipc_unregister_notifier(struct notifier_block *nb)
>> +{
>> +	return atomic_notifier_chain_unregister(&ipc_notifier, nb);
>> +}
>> +EXPORT_SYMBOL(pl320_ipc_unregister_notifier);
> 
> I need all of your symbols to be exported with EXPORT_SYMBOL_GPL().
> 
> Is it OK to make that change when applying the patch or do you want to send
> a new one?

I probably should resend so I can include the drivers level Kconfig and
Makefile.

I'll get that out this morning.

--Mark Langsdorf
Calxeda, Inc.

