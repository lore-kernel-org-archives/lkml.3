Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaCHRMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 12:12:50 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:64309 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbaCHRMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 12:12:49 -0500
Message-ID: <1394298766.2741.7.camel@x220>
Subject: Re: perf samples too long without perf running (?!?)
From: Paul Bolle <pebolle@tiscali.nl>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 08 Mar 2014 18:12:46 +0100
In-Reply-To: <CALCETrW5Gpz7TYVVj2NxbKx4cFdePUQ1sEPDyLt5qLmy7KCycQ@mail.gmail.com>
References: <CALCETrWSyhJHwfKSBT3giSb0AtvHFBR9PYmhFhFJa=Yabw25iw@mail.gmail.com>
	 <1394265078.7215.11.camel@marge.simpson.net> <20140308091331.GA282@x4>
	 <CALCETrW5Gpz7TYVVj2NxbKx4cFdePUQ1sEPDyLt5qLmy7KCycQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2014 17:12:47.0753 (UTC) FILETIME=[A0DEF790:01CF3AF1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 08:22 -0800, Andy Lutomirski wrote:
> Is it just me or is this whole situation screwed up for multiple reasons?

One minor reason would be that this message should read (say) 
    perf samples taking too long (2503 ns > 2500 ns), [...]

At least, that's what I thought after diving into the code to see what
was causing warnings like these.

And, since apparently things are just fine without administrator
intervention, I'd say another minor reason is that printing this at
KERN_INFO or KERN_NOTICE level should be enough here.


Paul Bolle

