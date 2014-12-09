Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaLISVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:21:48 -0500
Received: from smtp07.online.nl ([194.134.42.52]:34860 "EHLO smtp07.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaLISVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:21:46 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 13:21:45 EST
Message-ID: <54873B8E.1060106@topic.nl>
Date: Tue, 09 Dec 2014 19:12:30 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
Organization: Topic
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/regulator/core.c: Don't print error on EPROBE_DEFER
References: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl> <20141209161420.GJ1934@sirena.org.uk>
In-Reply-To: <20141209161420.GJ1934@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Online-Scanned: by Cloudmark authority (on smtp07.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 05:14 PM, Mark Brown wrote:
>>If a regulator depends on another regulator that happens to be called
>>later, the kernel always prints a message like this:
>>   reg-fixed-voltage regulator_sd1: Failed to find supply vin
>>Since the deferral is not something fatal, nor even something the user
>>may need to be aware about, reduce the message to debug level.

Can we instead at least reduce it to WARN or INFO level then?

I have to explain over and over again that there's no problem when that 
message comes along ten times in a row. And it causes people to overlook 
the messages that really are errors.

-- 
Mike Looijmans
