Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab3BZRtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:49:00 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:54660 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3BZRs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:48:59 -0500
MIME-Version: 1.0
In-Reply-To: <512CF2C9.5060309@tomt.net>
References: <20130225221636.018756060@linuxfoundation.org>
	<512CF2C9.5060309@tomt.net>
Date: Tue, 26 Feb 2013 12:48:58 -0500
Message-ID: <CA+5PVA6=ZzxxvmnU3Dc-pfn2Qia721aeqfWczFBRoFZNH7D7yA@mail.gmail.com>
Subject: Re: [ 00/58] 3.7.10-stable review
From: Josh Boyer <jwboyer@gmail.com>
To: Andre Tomt <andre@tomt.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 12:37 PM, Andre Tomt <andre@tomt.net> wrote:
> Hi Greg, David.
>
> The patches for the sock_diag privilege escalation issue in 3.3-3.8 seems to
> be missing. Would be good to get those out the way before 3.7 is retired.
>
> http://comments.gmane.org/gmane.linux.network/260062

They aren't in Linus' tree yet.  They can't go into -stable until they
are.

> Hmm. Seems to be missing stable tag and CC. David?

He was already asked about this earlier.  Things are queued and working
through the process.

josh
