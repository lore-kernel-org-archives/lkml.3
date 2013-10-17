Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762773Ab3JQUbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:31:50 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44336 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab3JQUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:31:49 -0400
Message-ID: <52604933.20007@gmail.com>
Date: Thu, 17 Oct 2013 15:31:47 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paolo Pisati <paolo.pisati@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v2] TTY: hvc_dcc: probe for a JTAG connection before registering
References: <1379968234-23373-1-git-send-email-robherring2@gmail.com> <1380074758-19808-1-git-send-email-robherring2@gmail.com> <CAL_JsqK0hPtoD22fw3J+TmgNwJeJUYwjB9i1C4n817GvuOxQxw@mail.gmail.com> <20131017202047.GA24568@kroah.com>
In-Reply-To: <20131017202047.GA24568@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 03:20 PM, Greg Kroah-Hartman wrote:
> On Thu, Oct 17, 2013 at 02:16:37PM -0500, Rob Herring wrote:
>> On Tue, Sep 24, 2013 at 9:05 PM, Rob Herring <robherring2@gmail.com> wrote:
>>> From: Rob Herring <rob.herring@calxeda.com>
>>>
>>> Enabling the ARM DCC console and using without a JTAG connection will
>>> simply hang the system. Since distros like to turn on all options, this
>>> is a reoccurring problem to debug. We can do better by checking if
>>> anything is attached and handling characters. There is no way to probe
>>> this, so send a newline and check that it is handled.
>>>
>>> Cc: Paolo Pisati <paolo.pisati@canonical.com>
>>> Cc: Tim Gardner <tim.gardner@canonical.com>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: Jiri Slaby <jslaby@suse.cz>
>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>> ---
>>> v2: use time_is_after_jiffies
>>>
>>>  drivers/tty/hvc/hvc_dcc.c | 21 +++++++++++++++++++++
>>>  1 file changed, 21 insertions(+)
>>
>> Greg, Jiri,
>>
>> Can you please apply.
> 
> I already did, didn't you get an email saying it was applied to my tree?

Ah, yes. Found it buried in my work email. Sorry about that.

Rob

