Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbaDHQGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:06:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49597 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbaDHQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:06:08 -0400
Message-ID: <53441E69.5020701@oracle.com>
Date: Tue, 08 Apr 2014 12:06:01 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Lam <azl@google.com>
Subject: Re: [for-next][PATCH 14/14] tracing: Get trace_array ref counts when
 accessing trace files
References: <20130702202216.623562799@goodmis.org>	<20130702202427.455930200@goodmis.org>	<53401A3E.2090302@oracle.com>	<20140405143326.7c38ff91@gandalf.local.home>	<53406181.70805@oracle.com> <20140408114223.753bd633@gandalf.local.home>
In-Reply-To: <20140408114223.753bd633@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 11:42 AM, Steven Rostedt wrote:
> On Sat, 05 Apr 2014 16:03:13 -0400
> Sasha Levin <sasha.levin@oracle.com> wrote:
>  
>>> Thanks for the update. I run all my tests with lockdep enabled. I'm
>>> wondering if your config enable a lock that I don't have in my configs.
>>> Could you send me your .config please.
>>
>> Attached.
>>
> 
> Do you have any other configs that trigger this? This config is a
> monster and after I finally did get it to install, it just locked up on
> boot, with no messages.

Not really, that's the only one I use for fuzzing.

I'm running it in a vm, so maybe it's worth trying that?


Thanks,
Sasha

