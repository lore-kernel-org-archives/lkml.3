Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaGVPum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:50:42 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:58341 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755408AbaGVPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:50:41 -0400
Date: Tue, 22 Jul 2014 16:50:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>, Will Deacon <Will.Deacon@arm.com>,
        David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/5] lib/genalloc.c: Add genpool range check function
Message-ID: <20140722155012.GK2219@arm.com>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
 <1404324218-4743-3-git-send-email-lauraa@codeaurora.org>
 <CAOesGMiKBNDmJhiY-yK0uZmG-MnK82=ffNGxqasLKozqgpQQpw@mail.gmail.com>
 <53CD6F28.3080203@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CD6F28.3080203@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 08:51:04PM +0100, Laura Abbott wrote:
> On 7/9/2014 3:33 PM, Olof Johansson wrote:
> > On Wed, Jul 2, 2014 at 11:03 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
> >>
> >> After allocating an address from a particular genpool,
> >> there is no good way to verify if that address actually
> >> belongs to a genpool. Introduce addr_in_gen_pool which
> >> will return if an address plus size falls completely
> >> within the genpool range.
> >>
> >> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> > 
> > Reviewed-by: Olof Johansson <olof@lixom.net>
> > 
> > What's the merge path for this code? Part of the arm64 code that needs
> > it, I presume?
> 
> My plan was to have the entire series go through the arm64 tree unless
> someone has a better idea.

It's fine by me. But since it touches core arch/arm code, I would like
to see an Ack from Russell.

-- 
Catalin
