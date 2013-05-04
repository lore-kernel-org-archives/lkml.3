Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898Ab3EDSFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 14:05:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51615 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab3EDSFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 14:05:16 -0400
Date: Sat, 4 May 2013 20:12:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Emmanuel Benisty <benisty.e@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-ID: <20130504181245.GA9711@pd.tnic>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
 <CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
 <CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
 <CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
 <20130504155558.GA12870@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130504155558.GA12870@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 04, 2013 at 11:55:58AM -0400, Jörn Engel wrote:
> Blockconsole currently lives here:
> https://git.kernel.org/cgit/linux/kernel/git/joern/bcon2.git/

Tja, if only that were upstream...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
