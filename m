Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaGJPPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:15:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaGJPPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:15:01 -0400
Date: Thu, 10 Jul 2014 08:14:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: devres: Sort managed interfaces
Message-ID: <20140710151441.GB19022@kroah.com>
References: <1404919578-4457-1-git-send-email-geert+renesas@glider.be>
 <20140709233248.GA12171@kroah.com>
 <CAMuHMdUCo8xmRnSPcUeCVwuWf-9MEWMh+BbnThA2H4nVTv0-KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUCo8xmRnSPcUeCVwuWf-9MEWMh+BbnThA2H4nVTv0-KA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 09:34:33AM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Thu, Jul 10, 2014 at 1:32 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jul 09, 2014 at 05:26:18PM +0200, Geert Uytterhoeven wrote:
> >> Sort the list of managed interfaces and their lists of methods
> >> alphabetically, to reduce the risk of merge conflicts and duplicates.
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >> ---
> >> I got annoyed by the merge conflicts when merging several for-next
> >> branches a while ago, so I sorted the list after everything became
> >> quiet.
> >> ---
> >>  Documentation/driver-model/devres.txt | 108 +++++++++++++++++-----------------
> >>  1 file changed, 54 insertions(+), 54 deletions(-)
> >
> > What tree/version is this against?  I get merge issues with my
> > driver-core-next tree :(
> 
> Ah, I hadn't merged in your driver-core-next tree.
> So it's against v3.16-rc4.
> 
> You have on top:
> 
> commit b23b35445ec82cde8afac8ba86b57a66a5fa1734
> Author: Daniel Thompson <daniel.thompson@linaro.org>
> Date:   Thu Jul 3 10:05:02 2014 +0100
> 
>     Documentation: devres: Add devm_kmalloc() et al
> 
> commit c9d53c0f2d23c792e4b9cf1551b63de4516f839e
> Author: Jingoo Han <jg1.han@samsung.com>
> Date:   Wed Jun 11 14:00:05 2014 +0900
> 
>     devres: remove devm_request_and_ioremap()
> 
> Shall I update and resend?

Yes, please do.

thanks,

greg k-h
