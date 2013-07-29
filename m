Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3G2JPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:15:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45763 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab3G2JPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:15:08 -0400
Message-ID: <51F6327A.9090609@zytor.com>
Date: Mon, 29 Jul 2013 02:14:34 -0700
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
References: <alpine.LNX.2.00.1307231007490.14024@pobox.suse.cz> <tip-17f41571bb2c4a398785452ac2718a6c5d77180e@git.kernel.org> <51EFE5A8.1060109@linux.intel.com> <alpine.LNX.2.00.1307291106260.18809@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307291106260.18809@pobox.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 02:06 AM, Jiri Kosina wrote:
>>
>> Please note that putting this patch in perf/core means x86/jumplabel is
>> completely nonfunctional by itself.
> 
> I'd like to point out that this is still the case ... TIA,
> 

What is?

	-hpa

