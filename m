Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaEWUVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 16:21:52 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:45616 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaEWUVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 16:21:50 -0400
Date: Fri, 23 May 2014 22:21:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] sbus: Introduce the use of the managed version of kzalloc
Message-ID: <20140523202136.GA17307@ravnborg.org>
References: <20140522203536.GA16457@himangi-Dell>
 <20140523201703.GA17295@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523201703.GA17295@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 10:17:03PM +0200, Sam Ravnborg wrote:
> Hi Himangi.
> 
> On Fri, May 23, 2014 at 02:05:36AM +0530, Himangi Saraogi wrote:
> > This patch moves data allocated using kzalloc to managed data allocated
> > using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> > functions. The header file is added to make the devm function explicitly
> > available. Also, unnecessary assignment statements and labels are
> > removed.

Another note.
This patch touches only the display7seg dirver, so please prefix
your patch with "display7seg: bla bla"

	Sam
