Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbaHHQSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:18:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaHHQSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:18:43 -0400
Message-ID: <53E4F85D.2010001@redhat.com>
Date: Fri, 08 Aug 2014 18:18:37 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 8/8] x86: add comments about various syscall instructions,
 no code changes
References: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com> <1407250354-29525-9-git-send-email-dvlasenk@redhat.com> <20140805195821.GA30908@redhat.com>
In-Reply-To: <20140805195821.GA30908@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 09:58 PM, Oleg Nesterov wrote:
> On 08/05, Denys Vlasenko wrote:
>>
>> This patch adds comments which explain in detail
>> what registers are modified by each of these instructions.
>> The comments are placed immediately before corresponding
>> entry and exit points.
> 
> This is great ;)

I just discovered that I misunderstood how _exactly_
SYSCALL decides whether to save rflags to r11 or not.

(Wrote an actual testcase for 32bit -> 64bit SYSCALL
transition. Practice always trumps theory, doesn't it? ;)

So I had to fix my comments in this patch. I guess
I need to send v4 of the patchset now...

