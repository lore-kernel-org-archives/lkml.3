Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaHXSte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 14:49:34 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62031 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaHXStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 14:49:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwZP1gyf=mvTrKjWwj6YE6=5y1+aZdmsNMHUp6d3dckXw@mail.gmail.com>
References: <53F9CC77.70009@t-online.de>
	<CA+55aFwZP1gyf=mvTrKjWwj6YE6=5y1+aZdmsNMHUp6d3dckXw@mail.gmail.com>
Date: Sun, 24 Aug 2014 11:49:31 -0700
X-Google-Sender-Auth: Zshf3NlR1yE5NhIvLI_ZCanaYzA
Message-ID: <CA+55aFwNrUvZYDOPHK0WS8p+t3PFyRjfoSw1HGUGxPvEiO7HmQ@mail.gmail.com>
Subject: Re: [Bug 3.14.17] inconsistent lock state
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Knut Petersen <Knut_Petersen@t-online.de>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Renninger <trenn@suse.de>, David Miller <davem@davemloft.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 10:50 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Aug 24, 2014 at 4:28 AM, Knut Petersen
> <Knut_Petersen@t-online.de> wrote:
>>
>> Since months the postmaster wantonly blocks all mail traffic from the
>> biggest german ISP t-online.de to all vger.kernel.org mailing lists,
>> therefore I could not cc lkml.
>
> Hmm.

Looks like t-online used to have serious spam problems, with lots of
bad users etc.

Judging by googling, that _seems_ to have been fixed, and maybe vger
should unblock it again. Davem?

            Linus
