Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815Ab3EDRXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 13:23:22 -0400
Received: from longford.logfs.org ([213.229.74.203]:59008 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761696Ab3EDRXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 13:23:20 -0400
Date: Sat, 4 May 2013 11:55:58 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-ID: <20130504155558.GA12870@logfs.org>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
 <CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
 <CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
 <CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 March 2013 10:19:16 +0700, Emmanuel Benisty wrote:
> 
> I could reproduce it but could you please let me know what would be
> the right tools I should use to catch the original oops?
> This is what I got but I doubt it will be helpful:
> http://i.imgur.com/Mewi1hC.jpg

You could use either netconsole or blockconsole.  Netconsole requires
a second machine to capture the information, blockconsole requires a
usb key or something similar to write to.  In both cases you will get
the entire console output in a file, often including very helpful
messages leading up to the crash.

Blockconsole currently lives here:
https://git.kernel.org/cgit/linux/kernel/git/joern/bcon2.git/

Jörn

--
Unless something dramatically changes, by 2015 we'll be largely
wondering what all the fuss surrounding Linux was really about.
-- Rob Enderle
