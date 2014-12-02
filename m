Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbaLBFx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:53:57 -0500
Received: from ozlabs.org ([103.22.144.67]:53850 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaLBFxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:53:55 -0500
Message-ID: <1417499634.31336.9.camel@concordia>
Subject: Re: [PATCH 3/3] selftests/kcmp: Always try to build the test
From: Michael Ellerman <mpe@ellerman.id.au>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, shuahkh@osg.samsung.com,
        linux-api@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Date: Tue, 02 Dec 2014 16:53:54 +1100
In-Reply-To: <20141023060912.GD16267@moon>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
	 <1414040834-30209-3-git-send-email-mpe@ellerman.id.au>
	 <20141023060912.GD16267@moon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-23 at 10:09 +0400, Cyrill Gorcunov wrote:
> On Thu, Oct 23, 2014 at 04:07:14PM +1100, Michael Ellerman wrote:
> > Don't prevent the test building on non-x86. Just try and build it and
> > let the chips fall where they may.
> > 
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> 
> kcmp depends on checkpoint/restore config symbol which is known
> to work on x86 and (iirc) on arm, that's why x86 was only allowed.
> I don't mind to such change but not sure.
 
Yeah I understand. It's helpful for the other architectures to be able to build
the test, that way we at least know that it's something we should think about
implementing/fixing. If the test doesn't build at all then we just ignore it :)

cheers


