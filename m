Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab3AZAZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:25:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60729 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3AZAZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:25:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
Date: Sat, 26 Jan 2013 00:25:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <5102BB38.3050207@imgtec.com>
In-Reply-To: <5102BB38.3050207@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301260025.10020.arnd@arndb.de>
X-Provags-ID: V02:K0:hoHX3TYhO5goUwWGlnDJpbekKeZFd8leOmaLW2wKzpq
 oE182j0jOLaPafM5T9248c13duo87+PZxl362gGyhYbMh1BSOC
 oInHyQJ7Lp9Ig9pew2X/DSqAUKTqEAiRGqrPIDtygSAN9n2xhN
 mms4aXCx6fWz/2FBLzM6ajLgQwA+W16ARIORV/uu/gFoe+EWEi
 kEmRACEzX18OUO3Grp+O0csWoppMGmUBQARn9sY4qyBq8XC8KV
 NcvCBe0GZnZobgIAulkFe9rczimmxyB9amJrstalDg4eNRCc/w
 zqN0nhPzpI0B7lqQ1erWHayEgla52St0K2qGvZvcmkd/f8O4bk
 ng88rO72JqUT/RDcxlGo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2013, James Hogan wrote:
> Hi Arnd,
> 
> On 10/01/13 15:30, James Hogan wrote:
> > This patchset adds core architecture support to Linux for Imagination's
> > Meta ATP (Meta 1) and HTP (Meta 2) processor cores. Most of the feedback
> > from the RFC and v2 patchsets has now been addressed. All further
> > feedback is most welcome.
> > 
> > The patches are based on next-20130110, and can also be found in the
> > following git tree:
> >   git://github.com/jahogan/metag-linux.git metag-core
> 
> Review seems to have gone quiet. I'm fairly happy with this core
> patchset in it's currently form (only trivial alterations required since
> the v3 patches, e.g. some review comments and rebasing on linus/master),
> and would like to get it into the v3.9 merge window. What's the best way
> forward? I presume I need to get acks on each individual patch?


I've just looked through the entire series once more and could not find
any show-stoppers. I consider this ready for 3.9, and I'm also quite happy
with Vineet's ARC port, although I think he is still integrating some
feedback comments.

I'd suggest that you both ask Stephen to add the trees to linux-next
now (I thought you had done that already, but I don't see them there
at the moment).

You don't need Acked-by statements on every single patch, but having
more of those is certainly benefitial. When it comes to the merge
window, please send a pull request to Linus, and keep me on Cc,
so I can weigh in with an additional Ack to the series.

Until then, maybe you can have another look at each other's architecture
trees (ARC and Meta). Since you are in exactly the same situation with
upstream integration now, you are probably the best people to review
the code, and you providing ACKs and constructive feedback to the other
tree will helps others see that you are up to the job as an arch
maintainer. I have also given a few comments to one of you that
may actually apply to the other one just as well, but I can't remember
now what I discussed with whom ;-)

	Arnd
