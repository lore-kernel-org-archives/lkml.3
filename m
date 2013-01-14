Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037Ab3ANVuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:50:39 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39190 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931Ab3ANVuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:50:37 -0500
Message-ID: <50F47DA3.8000103@linux.vnet.ibm.com>
Date: Mon, 14 Jan 2013 16:50:27 -0500
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Paul Moore <pmoore@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        jmorris@namei.org, wad@chromium.org, otubo@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/3] seccomp: Add SECCOMP_RET_INFO return value
References: <1357578545-2396-1-git-send-email-coreyb@linux.vnet.ibm.com> <4315919.Nu3gOqZ3yQ@sifl>
In-Reply-To: <4315919.Nu3gOqZ3yQ@sifl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011421-7182-0000-0000-0000046AA9AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/14/2013 04:45 PM, Paul Moore wrote:
> On Monday, January 07, 2013 12:09:03 PM Corey Bryant wrote:
>> Adds a new return value to seccomp filters that causes an
>> informational kernel message to be printed.  The message
>> includes the system call number and architecture.
>>
>> This can be used to learn the system calls that a process
>> is using.
>>
>> Signed-off-by: Corey Bryant <coreyb@linux.vnet.ibm.com>
>
> Were do things currently stand with this patchset?  It still seems like a
> reasonable addition to me.
>

Thanks for asking.  I haven't heard anything in response to the v2 
patches.  Does anyone have any comments/thoughts?

-- 
Regards,
Corey Bryant

