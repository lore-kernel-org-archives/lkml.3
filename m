Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaFPTAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:00:36 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:3622 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbaFPTAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:00:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswPAHASn1NbtAal/2dsb2JhbABagw1SgXWoVAEBAQEBAQUBmSACAgGBEBd1hAMBAQQBJxMPDSMFCwgDDgouOR4GE4g6DAHPKheFY4kTB4RDAQOaQgGLMIgog0I7
Date: Mon, 16 Jun 2014 20:59:19 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2] fs/omfs/inode.c: use ULLONG_MAX instead of ~0ULL
Message-Id: <20140616205919.5740bea0522043fdfd32e98c@skynet.be>
In-Reply-To: <20140615161142.GC15404@localhost>
References: <1402814360-3122-1-git-send-email-fabf@skynet.be>
	<20140615161142.GC15404@localhost>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2014 12:11:42 -0400
Bob Copeland <me@bobcopeland.com> wrote:

> On Sun, Jun 15, 2014 at 08:39:20AM +0200, Fabian Frederick wrote:
> > Use more explicit kernel.h definition
> >  	array_size = DIV_ROUND_UP(bitmap_size, sb->s_blocksize);
> >  
> > -	if (sbi->s_bitmap_ino == ~0ULL)
> > +	if (sbi->s_bitmap_ino == ULLONG_MAX)
> >  		goto out;
> 
> So I agree they are the same, but is there a good reason for the
> change?
> 
> Semantically, I think of ~0ULL as "all ones" whereas ULLONG_MAX
> as a maximum of a magnitude comparison, which this is not really.

Well it was meant to clarify code but in this case it doesn't indeed :)

Thanks,
Fabian

> 
> -- 
> Bob Copeland %% www.bobcopeland.com
