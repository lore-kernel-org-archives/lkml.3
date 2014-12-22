Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaLVXWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:22:13 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:49999 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbaLVXWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:22:12 -0500
Message-ID: <1419290529.30945.61.camel@x220>
Subject: Re: Linux 3.19-rc1 - merge window closed
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sid Boyce <sboyce@blueyonder.co.uk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Drysdale <drysdale@google.com>, Michal Marek <mmarek@suse.cz>
Date: Tue, 23 Dec 2014 00:22:09 +0100
In-Reply-To: <CA+55aFxvP8i37MUkioxs6wjT8WKdTPuLrMiV0NZLYyGKpjeomg@mail.gmail.com>
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>
	 <1419145899.8696.5.camel@haakon3.risingtidesystems.com>
	 <20141222124310.b35177e67db8d76b64ec55f6@linux-foundation.org>
	 <alpine.LRH.2.00.1412222156260.29843@twin.jikos.cz>
	 <1419288214.8696.14.camel@haakon3.risingtidesystems.com>
	 <CA+55aFxvP8i37MUkioxs6wjT8WKdTPuLrMiV0NZLYyGKpjeomg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Dec 2014 23:22:09.0354 (UTC) FILETIME=[1B98AAA0:01D01E3E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-22 at 15:02 -0800, Linus Torvalds wrote:
> Hmm. So it seems that there is something wrong with the dependency
> generation for the generated header files. Possibly limited to just
> the uapi files.
> 
> But I can't seem to recreate it even by trying to first build 3.18-rc2
> and then switching to 3.19-rc1. So there's something
> not-very-straightforward going on, possibly including some nasty race
> in the Makefiles.

The basically random build failure in
https://lkml.org/lkml/2014/12/22/164 might be related. Still makes no
sense to me whatsoever.


Paul Bolle

