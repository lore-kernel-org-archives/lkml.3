Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbaAUWdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:33:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:33891 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaAUWdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:33:11 -0500
Message-ID: <52DEF579.6080401@windriver.com>
Date: Tue, 21 Jan 2014 17:32:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 50/73] drivers/hwmon: delete non-required instances of
 include <linux/init.h>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com> <1390339396-3479-51-git-send-email-paul.gortmaker@windriver.com> <20140121213719.GA11888@roeck-us.net>
In-Reply-To: <20140121213719.GA11888@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-21 04:37 PM, Guenter Roeck wrote:
> On Tue, Jan 21, 2014 at 04:22:53PM -0500, Paul Gortmaker wrote:
>> None of these files are actually using any __init type directives
>> and hence don't need to include <linux/init.h>.  Most are just a
>> left over from __devinit and __cpuinit removal, or simply due to
>> code getting copied from one driver to the next.
>>
>> Cc: Jean Delvare <khali@linux-fr.org>
>> Cc: Guenter Roeck <linux@roeck-us.net>
>> Cc: lm-sensors@lm-sensors.org
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> Hi Paul,
> 
> nice cleanup. I applied it to my local repository to run
> a set of build tests with it.

Great -- sounds good, extra testing is always appreciated.

> 
> Assuming the plan is to push the changes through your tree:
> 
> Acked-by: Guenter Roeck <linux@roeck-us.net>

Yep, that is the general plan; thanks for the ack --added.

P.
--

> 
> Guenter
> 
