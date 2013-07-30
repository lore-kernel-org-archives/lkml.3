Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab3G3Okf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:40:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3G3Oke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:40:34 -0400
Date: Tue, 30 Jul 2013 07:39:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        bp@suse.de, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH resend] drop_caches: add some documentation and info
 message
Message-Id: <20130730073956.3047e3c7.akpm@linux-foundation.org>
In-Reply-To: <20130730125525.GB15847@dhcp22.suse.cz>
References: <1374842669-22844-1-git-send-email-mhocko@suse.cz>
	<20130729135743.c04224fb5d8e64b2730d8263@linux-foundation.org>
	<20130730074531.GA10584@dhcp22.suse.cz>
	<20130730012544.2f33ebf6.akpm@linux-foundation.org>
	<20130730125525.GB15847@dhcp22.suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013 14:55:25 +0200 Michal Hocko <mhocko@suse.cz> wrote:

> > > I am OK with that  but can we use a top bit instead. Maybe we never have
> > > other entities to drop in the future but it would be better to have a room for them
> > > just in case.
> > 
> > If we add another flag in the future it can use bit 3?
> 
> What if we get crazy and need more of them?

Then we use bit 4.  Then 5.  Then 6.

I'm really not understanding your point here ;)
