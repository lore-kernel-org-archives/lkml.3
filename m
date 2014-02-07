Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbaBGH2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:28:46 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35703 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaBGH2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:28:45 -0500
Message-ID: <52F48B66.9070407@gmail.com>
Date: Fri, 07 Feb 2014 08:29:42 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bastien Traverse <bastien.traverse@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.12: ethernet controller missing after resuming from suspend
 to RAM
References: <52F2CC7B.80406@gmail.com> <52F33BE7.2040607@gmail.com> <2240387.gpLEHJv4c1@vostro.rjw.lan> <52F4179C.70400@gmail.com>
In-Reply-To: <52F4179C.70400@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 12:15 AM, Bastien Traverse wrote:
> 
> I was also hit by the rtsx driver bug
> (https://bugs.archlinux.org/task/37720) and was delighted with its fast
> resolution. I was hoping that its fix would also address the
> disappearing Ethernet bug.

yeah, but calling this "fast resolution" is quite incorrect.

I don't blame anyone for this and I'm quite happy that a workaround has
been found at last but calling this "fast resolution" is a bit funny
compare to the PITA it was to debug this.

That's probably why I haven't tried to do a similar work for this bug.

Thanks.

