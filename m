Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3H0Pwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:52:39 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:38922 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3H0Pwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:52:38 -0400
Message-ID: <521CCB2F.50407@xs4all.nl>
Date: Tue, 27 Aug 2013 17:52:15 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: weird keyboard issue (ps/2 port?) 3.9.x/3.10.x?
References: <521AED72.8050105@xs4all.nl> <521CC85D.6000009@hurleysoftware.com>
In-Reply-To: <521CC85D.6000009@hurleysoftware.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-08-27 17:40, Peter Hurley wrote:
> [ +cc Greg KH, Jiri S ]
> 
> On 08/26/2013 01:53 AM, Udo van den Heuvel wrote:
>> Hello,
>>
>> I am stuck with a weird keyboard related issue:
>> Since a few weeks I see loads of ^@^@^@^@^@^@ appear on the text console
[...]
>> What could this be?
>> Is it really a software issue?
>> If so: how could I help fix this?
> 
> What changed 'a few weeks' ago when this problem started?

I upgraded to Fedora 19 (from F17) and rebuilt kernels.
I rebuilt some kernels, found the fix to the encrypted swap activation
issue, etc.
I'd have to look up the date, but around july 14th?
Due to unfortunate changes in systemd I could not boot older kernels
anymore in F19 and needed that swap fix (remove /sbin/hotplug helper
definition). 3.9.9 is oldest one that boots but shows the issue(s).
I am now rebuilding 3.8.5 to see if that makes a difference for any of
these issues.

> I noticed your USB post as well. Did that problem start at the same time
> with the same change?

First alone the USB issue was present, later the PS/2 issue started but
(stupidly) I failed to note the kernel version. (or date) (but it was
post F19 migration)

I did not find any stuff in /var/log/messages that correlates with the
'ps/2' issue. (ps/2 as that is the interface of my keyboard but the
source could be elsewhere)
I will retest if the ps/2 issue is also present without keyboard connected.
I will see if the ~2 day delay from boot is consistent with the issue
occurring.

Udo
