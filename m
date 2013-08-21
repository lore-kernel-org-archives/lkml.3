Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3HUFKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:10:45 -0400
Received: from mail.southpole.se ([37.247.8.11]:42414 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab3HUFKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:10:44 -0400
Message-ID: <52144BC9.9030007@southpole.se>
Date: Wed, 21 Aug 2013 07:10:33 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH 2/4] openrisc: remove undefined of_get_cpu_node declaration
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376586580-5409-3-git-send-email-Sudeep.KarkadaNagesha@arm.com> <520DF3BD.2070904@arm.com>
In-Reply-To: <520DF3BD.2070904@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13137) on assp.southpole.se
X-Assp-ID: assp.southpole.se 61833-03932
X-Assp-Session: 7F858A111FD8 (mail 1)
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/13 11:41, Sudeep KarkadaNagesha wrote:
> On 15/08/13 18:09, Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> This patch removes the declaration of the function 'of_get_cpu_node'
>> which is not defined for openrisc. This is in preparation to move
>> it's definition from PPC to DT common code.
>>
>> Again it could be there as it was originally copied from powerpc.
>>
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>> Cc: Jonas Bonn <jonas@southpole.se>
> Hi Jonas,
>
> Since both microblaze and openrisc have moderated lists which I am not
> member of, these patches were blocked. Michal Simek agreed to remove
> this for microblaze. Do you see any concern with this patch for openrisc
> ? Can I have you ACK if it looks fine ?

Hi Sudeep,
Yes, thanks, the patch looks good.

Acked-by: Jonas Bonn <jonas@southpole.se>

/Jonas

>
> Regards,
> Sudeep
>> ---
>>   arch/openrisc/include/asm/prom.h | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/arch/openrisc/include/asm/prom.h b/arch/openrisc/include/asm/prom.h
>> index bbb34e5..eb59bfe 100644
>> --- a/arch/openrisc/include/asm/prom.h
>> +++ b/arch/openrisc/include/asm/prom.h
>> @@ -44,9 +44,6 @@ void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
>>   
>>   extern void kdump_move_device_tree(void);
>>   
>> -/* CPU OF node matching */
>> -struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
>> -
>>   /* Get the MAC address */
>>   extern const void *of_get_mac_address(struct device_node *np);
>>   
>>
>

