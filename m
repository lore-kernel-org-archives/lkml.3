Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaIQQHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:07:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34533 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbaIQQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:07:50 -0400
Message-ID: <1410970062.15235.28.camel@fourier>
Subject: Re: [PATCH 3.13 104/187] Revert "selinux: fix the default socket
 labeling in sock_graft()"
From: Kamal Mostafa <kamal@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Paul Moore <pmoore@redhat.com>
Date: Wed, 17 Sep 2014 09:07:42 -0700
In-Reply-To: <1410952107.3040.97.camel@decadent.org.uk>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
	 <1410818997-9432-105-git-send-email-kamal@canonical.com>
	 <1410952107.3040.97.camel@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-17 at 12:08 +0100, Ben Hutchings wrote:
> On Mon, 2014-09-15 at 15:08 -0700, Kamal Mostafa wrote:
> > 3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Paul Moore <pmoore@redhat.com>
> > 
> > commit 2873ead7e46694910ac49c3a8ee0f54956f96e0c upstream.
> > 
> > This reverts commit 4da6daf4d3df5a977e4623963f141a627fd2efce.
> [...]
> 
> Which is earlier in this series (72).  Shouldn't you drop them both?
> 
> Ben.
> 

Yes, I sure should have dropped them both.  And now I have.

Thanks very much, Ben!

 -Kamal


