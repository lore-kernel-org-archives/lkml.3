Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab3EHS3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:29:52 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:39000 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757561Ab3EHS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:29:51 -0400
Date: Wed, 8 May 2013 18:29:49 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tony Lindgren <tony@atomide.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>
Subject: Re: [GIT PULL] SLAB changes for v3.10
In-Reply-To: <alpine.DEB.2.02.1305081309310.3124@gentwo.org>
Message-ID: <0000013e85680f77-c90af647-7a17-4170-918d-ecaf796b5385-000000@email.amazonses.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org> <20130508003022.GS28721@atomide.com> <20130508042422.GU28721@atomide.com> <0000013e846d76c8-d376963d-e953-4eff-92ea-742ba09cdb98-000000@email.amazonses.com> <20130508154518.GW28721@atomide.com>
 <alpine.DEB.2.02.1305081309310.3124@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.02.1305081309312.3124@gentwo.org>
Content-Disposition: INLINE
X-SES-Outgoing: 2013.05.08-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The 1.4.0 verion in ubuntu 13.04 s not good enough?

qemu 1.4.0 reproduces the bug here on arm. And Chris Mason;s patch fixes
it.

