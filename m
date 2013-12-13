Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab3LMVPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:15:49 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:40510 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3LMVPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:15:47 -0500
Date: Fri, 13 Dec 2013 16:15:43 -0500
From: Tejun Heo <tj@kernel.org>
To: Levente Kurusa <levex@linux.com>
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: provide the ability to disable a disk via the
 params.
Message-ID: <20131213211543.GI27070@htj.dyndns.org>
References: <1386464187-6993-1-git-send-email-robbat2@gentoo.org>
 <20131212133935.GA32683@htj.dyndns.org>
 <robbat2-20131212T200207-028507804Z@orbis-terrarum.net>
 <52AA1E67.6000801@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AA1E67.6000801@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 09:36:55PM +0100, Levente Kurusa wrote:
> >1.
> >Countering your nodisable comment, would it be valid to do:
> >libata.force=2:disable libata.force=2.02:nodisable
> >To disable all of port 2 except device 2?
> 
> I think that makes sense and I support having 'nodisable'.

I really don't want to.  Let's please add whatever is necessary for
fringe use cases but no more.  It's not like this thing is generally
useful.

> >2. One of my friends wondered if it would be worthwhile to add force
> >keywords for other HORKAGE bits, and if so, should the
> >ata_lflag/ata_link force bits also be presented?
> 
> I don't think so. Most of the other HORKAGEs are automatically
> recognized and applied by the code. I think the only ones
> which can cause trouble if not detected at first are the ones that are
> currently in the list.

Again, just whatever is immediately necessary, please.

Thanks.

-- 
tejun
