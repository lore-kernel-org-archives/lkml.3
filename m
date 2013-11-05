Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3KEUdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:33:17 -0500
Received: from dkim2.fusionio.com ([66.114.96.54]:37317 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3KEUdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:33:15 -0500
X-ASG-Debug-ID: 1383683594-03d6a54d1810ddd0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Olof Johansson <olof@lixom.net>, Jens Axboe <axboe@kernel.dk>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <CAOesGMj1xXXM-gNgWQwBKOczpJtM7CobYy4h7Fe=4W3U43EJGQ@mail.gmail.com>
CC: Tushar Behera <tushar.behera@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com>
 <52794823.7080503@kernel.dk>
 <CAOesGMj1xXXM-gNgWQwBKOczpJtM7CobYy4h7Fe=4W3U43EJGQ@mail.gmail.com>
Message-ID: <20131105203308.3802.45122@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: Boot failure on Arndale with next-20131105
Date: Tue, 5 Nov 2013 15:33:08 -0500
X-ASG-Orig-Subj: Re: Boot failure on Arndale with next-20131105
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1383683594
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.142084
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Olof Johansson (2013-11-05 15:23:51)
> On Tue, Nov 5, 2013 at 11:33 AM, Jens Axboe <axboe@kernel.dk> wrote:

[ horrible crashes fixed by removing my patch ]

> > Very weird! What file system is being used?
> 
> Most of my failures have happened on regular MMC cards with ext4
> filesystems on them.
> 
> Note that the panic happens during device probe / partition table
> scanning, not after mounting the filesystem.
> 
> Giving your patch a go now across the board. I'm very concerned about
> the reports of bisectability, build failures and heaps of warnings
> though. Did the 0-day builder pick up any of those? :-/
> 

Hmmm, is bcache in your config?

-chris

