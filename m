Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaGGM4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:56:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35798 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaGGM4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:56:52 -0400
Date: Mon, 7 Jul 2014 13:55:54 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: jejb@parisc-linux.org, deller@gmx.de, tiwai@suse.de, jkosina@suse.cz,
        dave.anglin@bell.net, joe@perches.com, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parisc: Remove sizeof(frame) from call to get_sigframe
Message-ID: <20140707135554.1c52342c@alan.etchedpixels.co.uk>
In-Reply-To: <1404530457-4739-1-git-send-email-xerofoify@gmail.com>
References: <1404530457-4739-1-git-send-email-xerofoify@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Jul 2014 23:20:57 -0400
Nicholas Krause <xerofoify@gmail.com> wrote:

> This removes the sizeof(frame) from the call to get_sigframe on line
> 243 in order to fix the call to this function as the sizeof in not
> needed to call this function.

If you are going to submit patches then

- actually read what you are submitting

- check it actually compiles

- run it on the system in question and verify your changed code paths are
  used

*then* consider submitting it, otherwise all you are doing is wasting
people's time.

Alan
