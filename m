Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3AKMo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:44:28 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52438 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3AKMo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:44:27 -0500
Message-ID: <50F00926.3070000@suse.cz>
Date: Fri, 11 Jan 2013 13:44:22 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Florian Westphal <fw@strlen.de>
CC: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, gregkh@linuxfoundation.org,
        frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
References: <20130110144626.GA26279@breakpoint.cc> <20130110155058.12f66e73@bob.linux.org.uk> <20130110162907.GB26279@breakpoint.cc> <50EEF8FD.9000004@suse.cz> <20130110224554.1724a791@bob.linux.org.uk> <50EF45DF.4010905@suse.cz> <50EFF366.2000303@suse.cz> <20130111124129.GA23516@breakpoint.cc>
In-Reply-To: <20130111124129.GA23516@breakpoint.cc>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 01:41 PM, Florian Westphal wrote:
> Jiri Slaby <jslaby@suse.cz> wrote:
>> On 01/10/2013 11:51 PM, Jiri Slaby wrote:
>>> On 01/10/2013 11:45 PM, Alan Cox wrote:
>>>> So we should just fix TIOCGPTN on a pty with no suitable name answer to
>>>> return -EINVAL
>>>
>>> Yes, I agree as I'm expressed in my second mail. Sorry for the confusion.
>>
>> Does the attached patch help?
> 
> Yes, it does.  Thanks for fixing this.

Ok, now I'm not sure if we want the patch or to implement TIOCGPTN
properly instead. Alan?
-- 
js
suse labs
