Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3G2JYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:24:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45853 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab3G2JYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:24:03 -0400
Message-ID: <51F63487.7040003@zytor.com>
Date: Mon, 29 Jul 2013 02:23:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, tglx@linutronix.de, fengguang.wu@intel.com,
        tip-bot for Jiri Kosina <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] kprobes/x86: Call out into INT3 handler directly
 instead of using notifier
References: <alpine.LNX.2.00.1307231007490.14024@pobox.suse.cz> <tip-17f41571bb2c4a398785452ac2718a6c5d77180e@git.kernel.org> <51EFE5A8.1060109@linux.intel.com> <alpine.LNX.2.00.1307291106260.18809@pobox.suse.cz> <51F6327A.9090609@zytor.com> <alpine.LNX.2.00.1307291116560.18809@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307291116560.18809@pobox.suse.cz>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 02:18 AM, Jiri Kosina wrote:
> On Mon, 29 Jul 2013, H. Peter Anvin wrote:
> 
>>>> Please note that putting this patch in perf/core means x86/jumplabel is
>>>> completely nonfunctional by itself.
>>>
>>> I'd like to point out that this is still the case ... TIA,
>>
>> What is?
> 
> 17f41571bb2c4a is only in perf/core, x86/jumplabel is missing it. I am not 
> sure about the tip workflow, but as it is now, x86/jumplabel is buggy, so 
> it should be either fixed (by pulling 17f41571bb2c4a from perf/core) or 
> removed, or somehow marked as broken ... ?
> 
> Not a big deal for me as long as perf/core is fine, but as you were 
> mentioning it ...
> 

Yes, we know.  In effect, x86/jumplabel not really a working standalone
topic branch at the moment.  It is probably not worth fixing it for this
kernel cycle, as the number of patches involved is relatively small, but
it is perhaps a bit unfortunate.

	-hpa


