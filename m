Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935799Ab3BOOua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:50:30 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:54151 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866Ab3BOOu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:50:29 -0500
Message-ID: <511E4B32.3030003@acm.org>
Date: Fri, 15 Feb 2013 08:50:26 -0600
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        Corey Minyard <cminyard@mvista.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Move console redirect to pid namespace
References: <1360376920-30824-1-git-send-email-minyard@acm.org> <20130209191409.643c3d7f@neptune.home> <87r4kkuj4o.fsf@xmission.com> <511D9890.1040900@acm.org> <87d2w29pdo.fsf@xmission.com>
In-Reply-To: <87d2w29pdo.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 10:23 PM, Eric W. Biederman wrote:
>
>>> With recent changes this is tied to the initial user namespace.  So the
>>> simple solution to this and so many other similiar security problems is
>>> to run your container in a user namespace.
>>>
>>> The permission check currently is capable(CAP_SYS_ADMIN) which requires
>>> the caller to have the CAP_SYS_ADMIN in the initial user namespace.
>> I'm not sure I follow.  Are these changes in k.org, or in another
>> repository someplace?
> In k.org. 3.7 would work. 3.8-rcX would work even better.
>
> root in a user namespace does not have permission to call TIOCCONS.

Ok, that's good enough for me.  I don't have a compelling reason to make 
it work, beyond liking consistency.

Thank you,

-corey
