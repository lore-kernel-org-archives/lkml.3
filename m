Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaIDWnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 18:43:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43451 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358AbaIDWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 18:43:49 -0400
Message-Id: <1409870628.2310799.163815377.623F33D2@webmail.messagingengine.com>
X-Sasl-Enc: k83OGV2m7iAV9QU/cfBTDpnzn21b/Iu2VmQij+lfjWn5 1409870628
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>, Sasha Levin <sasha.levin@oracle.com>
Cc: akpm@linuxfoundation.org, mingo@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-a219acad
Subject: Re: [PATCH] kernel: add support for gcc 5
Date: Fri, 05 Sep 2014 00:43:48 +0200
In-Reply-To: <20140904212535.GA5059@drone.musicnaut.iki.fi>
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
 <20140904212535.GA5059@drone.musicnaut.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 4, 2014, at 23:25, Aaro Koskinen wrote:
> On Thu, Sep 04, 2014 at 11:37:19AM -0400, Sasha Levin wrote:
> > We're missing include/linux/compiler-gcc5.h which is required now
> > because gcc branched off to v5 in trunk.
> > 
> > Just copy the relevant bits out of include/linux/compiler-gcc4.h,
> > no new code is added as of now.
> > 
> > This fixes a build error when using gcc 5.
> 
> With the new GCC version numbering scheme, does this mean there will
> be a new such file to be added every year? Maybe this could be handled
> some other way?

I agree, with the new gcc roadmap announced back in August [1] they tend
to increase the major number with each yearly release. I don't think it
is feasable to add a new header every year in a timely manner.

Most statements are already depending on GCC_VERSION, maybe we can just
unify all gcc specific headers to one, still trying to keep the file
organized? ;)

[1] https://gcc.gnu.org/develop.html (Section "Version Numbering Scheme
for GCC 5 and Up")

Bye,
Hannes
