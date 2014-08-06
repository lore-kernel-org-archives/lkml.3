Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaHFM2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:28:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39107 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbaHFM2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:28:36 -0400
Date: Wed, 6 Aug 2014 08:28:29 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Hariprasad S <hariprasad@chelsio.com>
Cc: Kyle McMartin <kyle@infradead.org>, linux-firmware@kernel.org,
        ben@decadent.org.uk, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: linux-firmware: update cxgb4 firmware
Message-ID: <20140806122829.GK18548@merlin.infradead.org>
References: <20140627120910.GA2406@hariprasad-pc>
 <20140804174831.GB20672@merlin.infradead.org>
 <20140806063628.GA7082@hariprasad-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806063628.GA7082@hariprasad-pc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 12:06:29PM +0530, Hariprasad S wrote:
> On Mon, Aug 04, 2014 at 13:48:31 -0400, Kyle McMartin wrote:
> > On Fri, Jun 27, 2014 at 05:39:11PM +0530, Hariprasad S wrote:
> > > Hi,
> > > 
> > > Can you please pull from the following URL?
> > >     git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
> > > 
> > 
> > Trying to pull this for you right now... git.chelsio.net seems to be
> > offline though.
> > 
> > regards, Kyle
> > 
> 
> My bad. We had some issue with our git server due to power-surge.
> Can you please retry now?
> 
> Thanks, Hari
> 

Worked this time... I just cherry-picked it in to avoid the unnecessary
merge commit.

--Kyle
