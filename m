Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaCaK0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:26:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbaCaK0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:26:37 -0400
From: Andreas Schwab <schwab@suse.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Struan Bartlett <struan.bartlett@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Support for netconsole as default tty/console?
References: <CAOte+=YgX=0dahqCS6-=yBLHnTjoJtii3Ycx4mhrj9SqNADZzg@mail.gmail.com>
	<87r45lqcm7.fsf@igel.home>
	<20140331111833.76af70e0@alan.etchedpixels.co.uk>
X-Yow: I selected E5...  but I didn't hear ``Sam the Sham and the Pharaohs''!
Date: Mon, 31 Mar 2014 12:26:35 +0200
In-Reply-To: <20140331111833.76af70e0@alan.etchedpixels.co.uk> (One Thousand
	Gnomes's message of "Mon, 31 Mar 2014 11:18:33 +0100")
Message-ID: <mvm4n2ehdes.fsf@hawking.suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> writes:

> Samo Pogacnik added a generic solution a few years ago. The ttyprintk
> driver provides you with a tty/console whose 'hardware' is printk and
> thus whatever system log device you are using.

Unfortunately it's an EXPERT setting, thus typically not avaiable.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
