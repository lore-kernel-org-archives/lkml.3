Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3KYPLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:11:10 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:51076 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3KYPLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:11:07 -0500
MIME-Version: 1.0
In-Reply-To: <52936145.8050807@ubuntu.com>
References: <52936145.8050807@ubuntu.com>
Date: Mon, 25 Nov 2013 10:11:06 -0500
X-Google-Sender-Auth: RhqsacoGQck4xHMVDQqdasTJqmw
Message-ID: <CA+5PVA73Jj1UDv+ONocxjtm92jPmXir13=7YpXLJXi1pZPXH7Q@mail.gmail.com>
Subject: Re: Depreciated and scheduled for removal
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 9:40 AM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> I swear there was a text file that listed features that were
> depreciated and scheduled for removal, but now I can not find it.  Did
> it get removed, or am I just daft?

It got removed because it was a source of merge conflicts, continually
out-of-date, and fairly pointless.

commit 9c0ece069b32e8e122aea71aa47181c10eb85ba7
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Oct 1 15:21:43 2012 -0700

    Get rid of Documentation/feature-removal.txt

josh
