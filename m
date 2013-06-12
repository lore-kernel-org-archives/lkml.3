Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3FLOpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:45:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44197 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3FLOpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:45:18 -0400
Date: Wed, 12 Jun 2013 10:30:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Luciano Coelho <coelho@ti.com>, Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: pull request: wireless 2013-06-06
Message-ID: <20130612143057.GA11589@tuxdriver.com>
References: <20130606190929.GB18827@tuxdriver.com>
 <20130611.222706.1492583255605214982.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611.222706.1492583255605214982.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 10:27:06PM -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Thu, 6 Jun 2013 15:09:30 -0400
> 
> > Johannes Berg (2):
> >       mac80211: constify ieee802_11_parse_elems() argument
> 
> Such cleanups are absolutely, positively, not appropriate at this
> time.
> 
> Sorry.
> 
> I still can't pull this.

OK, a respin is coming.

Note to my feeder trees, another rebase is coming...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
