Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaCQAFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 20:05:32 -0400
Received: from bes.se.axis.com ([195.60.68.10]:57147 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbaCQAFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 20:05:31 -0400
Date: Mon, 17 Mar 2014 01:05:24 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>,
        Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-m32r@ml.linux-m32r.org" <linux-m32r@ml.linux-m32r.org>,
        "microblaze-uclinux@itee.uq.edu.au" 
	<microblaze-uclinux@itee.uq.edu.au>,
        "linux-am33-list@redhat.com" <linux-am33-list@redhat.com>
Subject: Re: [PATCH 2/2] Cleanup useless architecture versions of
 scatterlist.h
Message-ID: <20140317000524.GE25718@axis.com>
References: <1394837930-27731-1-git-send-email-lauraa@codeaurora.org>
 <1394837930-27731-2-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394837930-27731-2-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 11:58:50PM +0100, Laura Abbott wrote:
> There's no need to have an architecture version of scatterlist.h
> if the only thing the file does is include asm-generic/scatterlist.h.
> Switch to the asm-generic versions directly.
> 
> Cc: Mikael Starvik <starvik@axis.com>

For the CRIS-part:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: David Howells <dhowells@redhat.com>
> Cc: Hirokazu Takata <takata@linux-m32r.org>,
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
> Cc: Chen Liqin <liqin.linux@gmail.com>,
> Cc: Lennox Wu <lennox.wu@gmail.com>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
