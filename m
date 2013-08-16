Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3HPInT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:43:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52912 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3HPInO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:43:14 -0400
Message-ID: <520DE627.2080007@arm.com>
Date: Fri, 16 Aug 2013 09:43:19 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "microblaze-uclinux@itee.uq.edu.au" 
	<microblaze-uclinux@itee.uq.edu.au>,
        "linux@openrisc.net" <linux@openrisc.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH 3/4] powerpc: refactor of_get_cpu_node to support
 other architectures
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1376586580-5409-4-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376628601.4255.138.camel@pasglop>
In-Reply-To: <1376628601.4255.138.camel@pasglop>
X-OriginalArrivalTime: 16 Aug 2013 08:43:10.0298 (UTC) FILETIME=[A3049BA0:01CE9A5C]
X-MC-Unique: 113081609431102501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/13 05:50, Benjamin Herrenschmidt wrote:
> On Thu, 2013-08-15 at 18:09 +0100, Sudeep KarkadaNagesha wrote:
>>                /* Check for ibm,ppc-interrupt-server#s. If it doesn't exist
>>                  * fallback to "reg" property and assume no threads
>>                  */
>> -
> 
> Oh and I forgot ... that comment is now wrong, since your code handles
> threads in the "reg" case...
> 
I have fixed it in the next patch while adding the documentation to
these function. I wanted changes in this patch minimal. I can fix it
here too if you insist on it.

Regards,
Sudeep


