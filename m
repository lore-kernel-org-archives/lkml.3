Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3HTHvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:51:13 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:36115 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3HTHvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130820072143.GJ27005@ZenIV.linux.org.uk>
References: <20130706000949.GD16853@hostway.ca>
	<CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
	<20130819201717.GA23608@hostway.ca>
	<0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
	<CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
	<20130820040648.GG27005@ZenIV.linux.org.uk>
	<CAEcaRjip29P8TdMHF8zJ3zzsQj7o_B9chEz7Q6xH0Bqtw3A-jg@mail.gmail.com>
	<20130820072143.GJ27005@ZenIV.linux.org.uk>
Date: Tue, 20 Aug 2013 00:51:11 -0700
Message-ID: <CAEcaRjg7GJhEbQoduup6xQKea4Pn4+SOgv8GbbJUeU=xR74dVQ@mail.gmail.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
From: Ian Applegate <ia@cloudflare.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>, Simon Kirby <sim@hostway.ca>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately no boxen with CONFIG_DEBUG_MUTEXES among them. I can
enable on a few and should have some results within the day. These
mainly serve (quite a bit of) HTTP/S cache traffic.

On Tue, Aug 20, 2013 at 12:21 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Aug 20, 2013 at 12:17:52AM -0700, Ian Applegate wrote:
>> We are also seeing this or a similar issue. On a fairly widespread
>> deployment of 3.10.1 & 3.10.6 this occurred fairly consistently on the
>> order of 36 days (combined MTBF.)
>
> Do you have any boxen with CONFIG_DEBUG_MUTEXES among those?  What
> kind of setup do you have on those, BTW?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
