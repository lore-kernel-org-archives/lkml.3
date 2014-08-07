Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbaHGFxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:53:24 -0400
Received: from s87.loopia.se ([194.9.94.112]:12741 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbaHGFxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:53:23 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <53E31462.2060800@hanshq.net>
Date: Wed, 06 Aug 2014 22:53:38 -0700
From: Hans Wennborg <hans@hanshq.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] cpufreq: fix decimal printf format specifiers prefixed
 with 0x
References: <1407300108-32186-1-git-send-email-hans@hanshq.net> <1494298.av10nJMuYA@vostro.rjw.lan>
In-Reply-To: <1494298.av10nJMuYA@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 01:35 PM, Rafael J. Wysocki wrote:
> On Tuesday, August 05, 2014 09:41:48 PM Hans Wennborg wrote:
>> The prefix suggests the number should be printed in hex, so use
>> the %x specifier to do that.
>>
>> Found by using regex suggested by Joe Perches.
>>
>> Signed-off-by: Hans Wennborg <hans@hanshq.net>
>
> This triggers a build warning related to the formats.  Care to fix up?

Sure. Sending a new patch, hopefully attached to the same thread (still 
working on my git send-mail skills).

  - Hans
