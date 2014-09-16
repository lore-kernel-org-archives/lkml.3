Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaIPW5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbaIPW5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:57:47 -0400
Message-ID: <5418C034.8020305@redhat.com>
Date: Tue, 16 Sep 2014 18:56:52 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org,
        rjw@rjwysocki.net, marc.zyngier@arm.com, mark.rutland@arm.com,
        Sudeep.Holla@arm.com, olof@lixom.net, grant.likely@linaro.org,
        graeme.gregory@linaro.org, arnd@arndb.de, jason@lakedaemon.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH for AMD Seattle 0/4] Drivers for AMD-Seatlle to boot
 from ACPI
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com> <5417BC57.4030504@amd.com>
In-Reply-To: <5417BC57.4030504@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 12:28 AM, Suravee Suthikulpanit wrote:
> Note: Correcting the typo for linux-acpi mailing list in this reply.
> 
> Also, I would like to add the link to the "AMD Opteron™ A1100 Series 
> Processor ACPI Porting Guide", which describes the current ACPI table 
> for AMD Seattle platform here:
> 
> http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2012/10/Seattle_ACPI_Guide.pdf

Thanks again for posting the patch series, and this document, which is
very useful. We have test systems running these patches right now, and
they work quite well. If anyone at Linaro Connect this week would like
to see hardware and get their own kernel built running these bits, let
myself, Suravee, or Al know and we'll help you make that happen.

Jon.

