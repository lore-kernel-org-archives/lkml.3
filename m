Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbaBFKIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:08:39 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59873 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbaBFKIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:08:35 -0500
Message-ID: <52F35DE0.3040402@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 15:33:12 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Jean Delvare <jdelvare@suse.de>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 42/51] hwmon, coretemp: Fix CPU hotplug callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205221205.19080.15108.stgit@srivatsabhat.in.ibm.com> <20140206004412.GA1308@roeck-us.net> <20140206012531.GA3887@roeck-us.net>
In-Reply-To: <20140206012531.GA3887@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020610-0260-0000-0000-0000045166A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 06:55 AM, Guenter Roeck wrote:
> On Wed, Feb 05, 2014 at 04:44:12PM -0800, Guenter Roeck wrote:
>> On Thu, Feb 06, 2014 at 03:42:06AM +0530, Srivatsa S. Bhat wrote:
>>> Subsystems that want to register CPU hotplug callbacks, as well as perform
>>> initialization for the CPUs that are already online, often do it as shown
>>> below:
[...]
>>> Fix the hwmon coretemp code by using this latter form of callback
>>> registration.
>>>
>>> Cc: Fenghua Yu <fenghua.yu@intel.com>
>>> Cc: Jean Delvare <jdelvare@suse.de>
>>> Cc: Guenter Roeck <linux@roeck-us.net>
>>> Cc: lm-sensors@lm-sensors.org
>>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>
>> Applied.
>>
> That obviously doesn't build ;-). Replace with 
> 
> Acked-by: Guenter Roeck <linux@roeck-us.net>
> 

Thanks a lot for the Ack! This patch has a dependency on Patch 1,
hence the trouble with applying it individually :(

Link to Patch 1:
http://article.gmane.org/gmane.linux.kernel/1641640

Regards,
Srivatsa S. Bhat

