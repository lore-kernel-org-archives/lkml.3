Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaKJMcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:32:53 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60145 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbaKJMcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:32:50 -0500
Message-ID: <1415622769.21229.15.camel@x220>
Subject: Re: MIPS: ralink: CONFIG_RALINK_ILL_ACC?
From: Paul Bolle <pebolle@tiscali.nl>
To: John Crispin <blogic@openwrt.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Nov 2014 13:32:49 +0100
In-Reply-To: <544E188B.9000707@openwrt.org>
References: <1414403681.28499.4.camel@x220> <544E188B.9000707@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2014 12:32:49.0369 (UTC) FILETIME=[70493C90:01CFFCE2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

This message never made it to my Inbox. I copied it from a mips' list
archive om the web. That kept this issue on my TODO list, although it
actually was resolved quite quickly.

On Mon, 2014-10-27 at 11:03 +0100, John Crispin wrote:
> On 27/10/2014 10:54, Paul Bolle wrote:
> > Your commit 78865eacb4aa ("MIPS: ralink: add illegal access
> > driver") landed in today's linux-next (ie, next-20141027). That
> > commit dates back to May 16, 2013! It adds a driver that is built
> > if CONFIG_RALINK_ILL_ACC is set. But there's no Kconfig symbol
> > RALINK_ILL_ACC.
> > 
> > I assume that patch that adds this symbol is queued somewhere. Is
> > that correct?
> 
> i'll look into it. the commit that move all dts files to a central
> folder broke some of my patches so i had to rebase them. apparently
> the bit that adds the symbol got lost.

(CONFIG_RALINK_ILL_ACC was already gone in next-20141029. So that issue
is resolved, as far as I care.)

> out of interest, how did you spot this ?

See https://lkml.org/lkml/2014/9/26/456:
    I have a 800 line perl monster that checks for stuff like this. It's not
    very sophisticated but smart enough to spot typos like this one. I try
    to have it check each linux-next (and mainline) release.

    (I think Valentin Rothberg is trying to automate this properly. See
    http://www.linuxplumbersconf.org/2014/ocw/sessions/1863 .)

This is the last time I'll put pressure on Valentin _publicly_, I
promise!


Paul Bolle

