Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaBZJ5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:57:20 -0500
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4705 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaBZJ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:57:17 -0500
Message-ID: <530DBA62.9060900@xs4all.nl>
Date: Wed, 26 Feb 2014 10:56:50 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH, RFC 05/30] [media] omap_vout: avoid sleep_on race
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-6-git-send-email-arnd@arndb.de> <52D90490.3080407@xs4all.nl> <201402261003.03076.arnd@arndb.de>
In-Reply-To: <201402261003.03076.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/14 10:03, Arnd Bergmann wrote:
> On Friday 17 January 2014, Hans Verkuil wrote:
>> On 01/02/2014 01:07 PM, Arnd Bergmann wrote:
>>> sleep_on and its variants are broken and going away soon. This changes
>>> the omap vout driver to use interruptible_sleep_on_timeout instead,
>>
>> I assume you mean wait_event_interruptible_timeout here :-)
>>
>> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> If there are no other comments, then I plan to merge this next week.
>>
> 
> Hi Hans,
> 
> Not sure if you merged the media patches into a local tree, but I see
> they are not in linux-next at the moment. I'll just re-send them,
> but please let me know if I can drop them on my end, or better
> make sure your tree is in linux-next if you have already picked them
> up.

I've picked it up, but it has not yet been merged. Mauro has been
traveling so not much has been merged recently.

Regards,

	Hans

