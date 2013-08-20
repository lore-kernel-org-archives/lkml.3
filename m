Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3HTHVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:21:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53178 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3HTHVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:21:49 -0400
Date: Tue, 20 Aug 2013 08:21:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Applegate <ia@cloudflare.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>, Simon Kirby <sim@hostway.ca>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
Message-ID: <20130820072143.GJ27005@ZenIV.linux.org.uk>
References: <20130706000949.GD16853@hostway.ca>
 <CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
 <20130819201717.GA23608@hostway.ca>
 <0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
 <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
 <20130820040648.GG27005@ZenIV.linux.org.uk>
 <CAEcaRjip29P8TdMHF8zJ3zzsQj7o_B9chEz7Q6xH0Bqtw3A-jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEcaRjip29P8TdMHF8zJ3zzsQj7o_B9chEz7Q6xH0Bqtw3A-jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 12:17:52AM -0700, Ian Applegate wrote:
> We are also seeing this or a similar issue. On a fairly widespread
> deployment of 3.10.1 & 3.10.6 this occurred fairly consistently on the
> order of 36 days (combined MTBF.)

Do you have any boxen with CONFIG_DEBUG_MUTEXES among those?  What
kind of setup do you have on those, BTW?
