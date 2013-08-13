Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3HMGXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:23:35 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59180 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755319Ab3HMGXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:23:32 -0400
X-Sasl-enc: J8JTMZqaPT1VyTmwCa4bMN05VcURByonqRyF5stOCC9D 1376374291
Date: Mon, 12 Aug 2013 23:12:56 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: linux-next: manual merge of the tty tree with the tile tree
Message-ID: <20130813061256.GA9854@kroah.com>
References: <20130813154346.fb2e52f791fb6e2e3e2fbfcc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813154346.fb2e52f791fb6e2e3e2fbfcc@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 03:43:46PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> include/uapi/linux/serial_core.h between commit 002abee2d681 ("tilegx:
> Add tty serial support for TILE-Gx on-chip UART") from the tile tree and
> commit c4b058560762 ("serial:st-asc: Add ST ASC driver") from the tty
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Fix looks fine to me, thanks.

greg k-h
