Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750776Ab3L2FCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 00:02:35 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:46067 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750704Ab3L2FCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 00:02:33 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Iu5Hnl6cLXBxtHkcbtYRNFRuEIFQBcSA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1979B4FD7F4
Date: Sun, 29 Dec 2013 00:02:30 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Git puzzle
Message-ID: <20131229050230.GL19878@titan.lakedaemon.net>
References: <201312282141.40725.gheskett@wdtv.com>
 <20131229043547.GJ19878@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131229043547.GJ19878@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene,

On Sat, Dec 28, 2013 at 11:35:47PM -0500, Jason Cooper wrote:
> On Sat, Dec 28, 2013 at 09:41:40PM -0500, Gene Heskett wrote:
...
> > working toward 3.8.3 which doesn't, and I have the disk space chowned
> > to me, what is the exact syntax to pull a clone of 3.8.2, and then do
> > a bisect to 3.8.3 where the microcode update for an AMD phenom doesn't
> > work. Skipping fwd to 3.12.0 it still isn't working.
> 
> The version tags you are referring to are from the linux-stable tree, so
> we'll clone that one instead of Linus'.

Just one small addendum to this:

Once you've identified the commit in the -stable tree, we'll have to
find the corresponding commit in the mainline tree.  Don't worry about
trying to find this for your initial email, just make sure to mention
that the commit identified is from the -stable tree between v3.8.2 and
v3.8.3.

thx,

Jason.
