Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3L1AQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 19:16:05 -0500
Received: from 5.array2.smtp.34sp.com ([46.183.10.83]:60527 "EHLO
	5.array2.smtp.34sp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3L1AQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 19:16:04 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Dec 2013 19:16:04 EST
Date: Sat, 28 Dec 2013 00:09:01 +0000
From: David Woodfall <dave@dawoodfall.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Problem with cpufreq and i5 since post 3.9.0
Message-ID: <20131228000900.GJ17115@Blackswan>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20131227185924.GH17115@Blackswan>
 <20131227194447.GA8188@fancy-poultry.org>
 <20131227195350.GI17115@Blackswan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20131227195350.GI17115@Blackswan>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Authenticated-As: unrealize.co.uk
X-OriginalSMTPIP: 82.44.71.14
Smarthost: 80.82.124.206
X-34SP-MailScanner-Information: Please contact the ISP for more information
X-34SP-MailScanner-ID: 940B4201EA.A1C83
X-34SP-MailScanner: Found to be clean
X-34SP-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0.001, required 6, URIBL_BLOCKED 0.00)
X-34SP-MailScanner-From: dave@dawoodfall.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (27/12/13 19:53), Dave Woodfall <dave@dawoodfall.net> put forth the proposition:
>On (27/12/13 20:44), Heinz Diehl <htd@fancy-poultry.org> put forth the proposition:
>>On 27.12.2013, David Woodfall wrote:
>>
>>>But any of the newer kernel versions I've tested only give me
>>>performance and powersave.
>>
>>I don't use any Fedora kernel, so I can't tell which governors are
>>enabled in those. You should check the value of "CONFIG_CPU_FREQ_GOV"
>>in the respective .config file for your installed kernel.
>>
>>In short: It seems that only "performance" and "powersave" are
>>compiled in.
>
>No, I used the same .config in all versions that I tested. I've also
>tried setting them as modules rather than built-in. This is the stock
>slackware .config:
>
>CONFIG_CPU_FREQ=y
>CONFIG_CPU_FREQ_TABLE=m
>CONFIG_CPU_FREQ_GOV_COMMON=y
>CONFIG_CPU_FREQ_STAT=m
>CONFIG_CPU_FREQ_STAT_DETAILS=y
># CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
>CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
># CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
># CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
>CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
>CONFIG_CPU_FREQ_GOV_POWERSAVE=m
>CONFIG_CPU_FREQ_GOV_USERSPACE=y
>CONFIG_CPU_FREQ_GOV_ONDEMAND=m
>CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
>
>And modprobing any governor module does not change the output of 
>scaling_available_governors.
>
>-Dave

I'm also experiencing this with a Intel G640 dual core machine.
Exactly the same effect.



