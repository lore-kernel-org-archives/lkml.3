Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3HFJCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:02:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57175 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab3HFJCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:02:42 -0400
Message-ID: <5200BBBA.7020303@arm.com>
Date: Tue, 06 Aug 2013 10:02:50 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 05/16] ARM: mvebu: remove device tree parsing for cpu
 nodes
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-6-git-send-email-Sudeep.KarkadaNagesha@arm.com> <51FA3064.9080502@arm.com> <20130801120256.GW5882@titan.lakedaemon.net> <51FFD2B1.70509@arm.com> <5200B2E9.8090009@free-electrons.com>
In-Reply-To: <5200B2E9.8090009@free-electrons.com>
X-OriginalArrivalTime: 06 Aug 2013 09:02:37.0379 (UTC) FILETIME=[B2858930:01CE9283]
X-MC-Unique: 113080610023904601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/13 09:25, Gregory CLEMENT wrote:
> On 05/08/2013 18:28, Sudeep KarkadaNagesha wrote:
>> On 01/08/13 13:02, Jason Cooper wrote:
>>> Sudeep,
>>>
>>> On Thu, Aug 01, 2013 at 10:54:44AM +0100, Sudeep KarkadaNagesha wrote:
>>>> On 22/07/13 12:32, Sudeep KarkadaNagesha wrote:
>>>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>>>
>>>>> Currently set_secondary_cpus_clock assume the CPU logical ordering
>>>>> and the MPDIR in DT are same, which is incorrect.
>>>>>
>>>>> Since the CPU device nodes can be retrieved in the logical ordering
>>>>> using the DT helper, we can remove the devices tree parsing.
>>>>>
>>>>> This patch removes DT parsing by making use of of_get_cpu_node.
>>>>>
>>>>> Cc: Gregory Clement <gregory.clement@free-electrons.com>
>>>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>>>> Cc: Jason Cooper <jason@lakedaemon.net>
>>>>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>>
>>>> Hi Gregory/Andrew/Jason,
>>>>
>>>> Does this change look fine for mvebu?
>>>> If yes, can I have your ACKs ?
>>>
>>> Gregory is the one best suited to review/Ack this.  He'll be back on
>>> Monday.
>>>
>> Hi Gregory,
>>
>> Can you please review this patch ?
> 
> Your patch is a nice improvement, I reviewed it and I also tested it on the
> Armada XP DB board.
> 
> You can add my:
> Acked-by: Gregory Clement <gregory.clement@free-electrons.com>

Thanks Gregory.

Regards,
Sudeep


