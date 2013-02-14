Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384Ab3BNOad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:30:33 -0500
Received: from mx0.parallels.com ([199.115.104.20]:36464 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204Ab3BNOac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:30:32 -0500
Message-ID: <511CF51C.6050504@parallels.com>
Date: Thu, 14 Feb 2013 18:30:52 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@ubuntu.com>
CC: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel: allow reboots from user_ns
References: <1360843000-31228-1-git-send-email-glommer@parallels.com> <20130214142745.GA4470@sergelap>
In-Reply-To: <20130214142745.GA4470@sergelap>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 06:27 PM, Serge Hallyn wrote:
> Quoting Glauber Costa (glommer@parallels.com):
>> Reboot support for pid namespaces is already implemented and it works
>> well. However, in most containers the tasks will join all namespaces,
>> including the now supported user namespace. In that situation, we will
>> fail the "capable" test and won't be able to reboot.
>>
>> The proposed solution is to allow reboots for CAP_SYS_BOOT processes
>> in the user namespace that owns the pid namespace.
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
> 
> Note Li Zefan sent this identical patch last year.  It's in my own
> built userns kernel, and definately required :)
> 
I didn't see that, and using Linus' master my stop container scripts
stopped working after I started using Eric's userns...

