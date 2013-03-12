Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab3CLQNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:13:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab3CLQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:13:07 -0400
Date: Tue, 12 Mar 2013 09:13:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Daniel Hellstrom <daniel@gaisler.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20130312161302.GA12317@core.coreip.homeip.net>
References: <20130312153047.dc10eb2392d07af8822e45f1@canb.auug.org.au>
 <513EF5DD.2010501@gaisler.com>
 <20130312225719.c70d478eff3e77633d029386@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312225719.c70d478eff3e77633d029386@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:57:19PM +1100, Stephen Rothwell wrote:
> On Tue, 12 Mar 2013 10:31:09 +0100 Daniel Hellstrom <daniel@gaisler.com> wrote:
> >
> > APBPS2 driver is missing linux/slab.h required on at least PowerPC. See patch below. How do you want me to proceed?
> 
> That is up to Dmitry - either a fix up patch (with SoB and commit
> message) or a replacement patch.

I fixed up the commit and refreshed the branch.

Thanks.

-- 
Dmitry
