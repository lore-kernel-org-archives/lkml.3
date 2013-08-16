Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3HPJlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:41:15 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35641 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3HPJlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:41:13 -0400
Message-ID: <520DF3BD.2070904@arm.com>
Date: Fri, 16 Aug 2013 10:41:17 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
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
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376586580-5409-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
In-Reply-To: <1376586580-5409-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 16 Aug 2013 09:41:08.0595 (UTC) FILETIME=[BC3E9C30:01CE9A64]
X-MC-Unique: 113081610411000201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/13 18:09, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> This patch removes the declaration of the function 'of_get_cpu_node'
> which is not defined for openrisc. This is in preparation to move
> it's definition from PPC to DT common code.
> 
> Again it could be there as it was originally copied from powerpc.
> 
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> Cc: Jonas Bonn <jonas@southpole.se>
Hi Jonas,

Since both microblaze and openrisc have moderated lists which I am not
member of, these patches were blocked. Michal Simek agreed to remove
this for microblaze. Do you see any concern with this patch for openrisc
? Can I have you ACK if it looks fine ?

Regards,
Sudeep
> ---
>  arch/openrisc/include/asm/prom.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/openrisc/include/asm/prom.h b/arch/openrisc/include/asm/prom.h
> index bbb34e5..eb59bfe 100644
> --- a/arch/openrisc/include/asm/prom.h
> +++ b/arch/openrisc/include/asm/prom.h
> @@ -44,9 +44,6 @@ void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
>  
>  extern void kdump_move_device_tree(void);
>  
> -/* CPU OF node matching */
> -struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
> -
>  /* Get the MAC address */
>  extern const void *of_get_mac_address(struct device_node *np);
>  
> 


