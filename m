Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbaBLVEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:04:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbaBLVEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:04:06 -0500
Date: Wed, 12 Feb 2014 16:03:47 -0500
From: Dave Jones <davej@redhat.com>
To: Kees Cook <kees@outflux.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        linux-kernel@vger.kernel.org
Subject: Re: flaw in "nf_tables: add reject module for NFPROTO_INET"
Message-ID: <20140212210347.GB6563@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kees Cook <kees@outflux.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
References: <52fb24097b42_6b5073486c727c3@209.249.196.67.mail>
 <20140212204307.GK23300@outflux.net>
 <20140212205037.GA6563@redhat.com>
 <20140212205453.GL23300@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212205453.GL23300@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 12:54:53PM -0800, Kees Cook wrote:
 > On Wed, Feb 12, 2014 at 03:50:37PM -0500, Dave Jones wrote:
 > > On Wed, Feb 12, 2014 at 12:43:08PM -0800, Kees Cook wrote:
 > >  > Hi,
 > >  > 
 > >  > This seems like a legit problem detected by Coverity. Looks like a break is
 > >  > missing?
 > > 
 > > yup, reported this morning. 
 > > (Also note that I changed the state in coverity once Patrick confirmed it)
 > 
 > Ah, sorry for the noise then! I missed Dave's earlier the bug report email.

I wonder if it's worth getting a coverity@vger.kernel.org list set up for
cc'ing stuff like this to reduce dupe reports (though this is the first I
recall in a while), and for review of patches etc before forwarding them on
to their relevant list/maintainers.

thoughts?

	Dave

