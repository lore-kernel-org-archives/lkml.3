Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab3COEDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:03:17 -0400
Received: from sender1.zohomail.com ([72.5.230.103]:60708 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3COEDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:03:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=message-id:date:from:user-agent:mime-version:to:subject:content-type; 
  b=qfBoa1GmzA5Gs4FqP8cHqJbLyUu365LGQ9yZOt+Qwij1STSuHOYJeObMzsll7seITaUMEpAn2Dvl
    5GMhDmGahnR1S5JxQ1ZEVHUWXGg5JP59UDYvwagT+gMZhfBhKXSF  
Message-ID: <51429998.4070005@zoho.com>
Date: Fri, 15 Mar 2013 04:46:32 +0100
From: Kevin Qiu <k_q_11@zoho.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: retreive /proc/acpi/processor?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Zoho-Virus-Status: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
     I am a newbie on Linux.
     I am trying to read the CPU information through "acpitool -c". And 
I get a message as: "  Function Show_CPU_Info : could not read directory 
/proc/acpi/processor/ Make sure your kernel has ACPI processor support 
enabled.
"
I went to the kernel configuration, it appears to me it's already 
enabled. And there're two tick box stating "deprecated /proc/acpi files, 
deprecated power /proc/acpi directories". Whether I tick it or not 
doesn't couldn't generate a new /proc/acpi/processor/
     So is there a way to bring this functionality back?
     P.S. I am using linux 3.2.0-23-generic kernel.
Kevin Qiu

