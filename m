Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161811AbaKNTqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:46:48 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41793 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161184AbaKNTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:46:47 -0500
Message-ID: <54665C24.9060605@linaro.org>
Date: Fri, 14 Nov 2014 13:46:44 -0600
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: akpm@linux-foundation.org, bobby.prani@gmail.com, pmladek@suse.cz,
        jack@suse.cz, mcgrof@suse.com, joe@perches.com,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] printk: drop logbuf_cpu volatile qualifier
References: <1415992771-9071-1-git-send-email-elder@linaro.org> <20141114144515.5b3e7d32@gandalf.local.home>
In-Reply-To: <20141114144515.5b3e7d32@gandalf.local.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 01:45 PM, Steven Rostedt wrote:
> On Fri, 14 Nov 2014 13:19:31 -0600
> Alex Elder <elder@linaro.org> wrote:
> 
>> Pranith Kumar posted a patch in which removed the "volatile"
>> qualifier for the "logbuf_cpu" variable in vprintk_emit().
>>     https://lkml.org/lkml/2014/11/13/894
>> In his patch, he used ACCESS_ONCE() for all references to
>> that symbol to provide whatever protection was intended.
>>
>> There was some discussion that followed, and in the end
>> Stephen Rostedt concluded that not only was "volatile" not
> 
> I don't know of a Stephen Rostedt. J

Sorry.  I'm sure that's a source of annoyance.  -Alex

>> needed, neither was it required to use ACCESS_ONCE().  I
>> offered an elaborate description that concluded Stephen
> 
> Who is this Stephen you talk about?

. . .

