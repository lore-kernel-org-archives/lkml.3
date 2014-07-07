Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaGGSWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:22:49 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:63585 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284AbaGGSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:22:48 -0400
Message-ID: <1404757366.2014.13.camel@x220>
Subject: Re: Arm Compiler - Part 1 of Compiling Tests
From: Paul Bolle <pebolle@tiscali.nl>
To: Nick Krause <xerofoify@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 07 Jul 2014 20:22:46 +0200
In-Reply-To: <CAPDOMVjEmVJJEd_LVpCkXC8qR7APTKeHNJQSQ5SFNuWj9BQuLA@mail.gmail.com>
References: <CAPDOMVieG951+0chzvjmKTdpZf-fEB5mjUL9YK-rgqF3+O537w@mail.gmail.com>
	 <20140707134637.GA31174@thunk.org>
	 <CAPDOMVjEmVJJEd_LVpCkXC8qR7APTKeHNJQSQ5SFNuWj9BQuLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2014 18:22:46.0079 (UTC) FILETIME=[73406CF0:01CF9A10]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 13:35 -0400, Nick Krause wrote:
> On the other hand there seems to be too many FIXMEs in the main
> kernel for one person to fix.

A quick grep for FIXMEs (also including the "XXX" pattern, which
basically means the same thing) triggers over 7000 hits. Even with a
(rather optimistic) one hour per FIXME that's over three years of work
(assuming a sane working hours/year metric).

Moreover, you appear to misunderstand the meaning of these FIXMEs. It's
not a marker for something trivial that somehow never got done. It might
actually mean all kind of things. In many cases it points at a hard, or
time consuming, etc., problem that no one has yet found a way, or the
time, to fix properly.

I would not advise someone new to the kernel to grep for FIXMEs to see
if they could contribute something. There are many things those people
could do, but those FIXMEs seem an awkward place to start.


Paul Bolle

