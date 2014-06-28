Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbaF1TSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:18:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54474 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaF1TSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 15:18:10 -0400
Date: Sat, 28 Jun 2014 20:18:04 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: stable@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cleanup of Kernel Bugzilla
Message-ID: <20140628201804.215ca896@alan.etchedpixels.co.uk>
In-Reply-To: <CAPDOMVjnROuS4D4E2B7=PxOZUB4YXHuFUKy5C9Y8Lm7gxN=N_Q@mail.gmail.com>
References: <CAPDOMVg=L+spebzkckNpM0=9NY=meV=F_+ko+VJN_6M50NdNew@mail.gmail.com>
	<CAPDOMVjnROuS4D4E2B7=PxOZUB4YXHuFUKy5C9Y8Lm7gxN=N_Q@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 22:45:47 -0400
Nick Krause <xerofoify@gmail.com> wrote:

> Do any of you use the kernel Bugzilla? If you do I was wondering if we
> can clean it up.

Developers are generally focussed on fixing bugs. Also the way bugzilla
works a lot of developers don't close the bugs and the originators never
get around to it.

Now if you want to clean up bugzilla then what would be really useful
(and probably quite tedious) is a list of all the bugs which end either in

- confirmation it is fixed, but the bug is not closed

- confirmation that it cannot be reproduced, but the bug is not closed

- with a question asking for more information which has had no reply in
  say 3 months

Given lists of bugs in those categories I can then go and zap them.

Alan
