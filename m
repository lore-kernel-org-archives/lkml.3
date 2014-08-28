Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaH1TaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:30:17 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48139 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaH1TaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:30:14 -0400
Date: Thu, 28 Aug 2014 15:16:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3 00/11] lib: introduce string_escape_mem and %*pE
 specifier
Message-ID: <20140828191637.GQ13758@tuxdriver.com>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20140828183330.GM13758@tuxdriver.com>
 <20140828120851.07dbd1c52ec287ca169acee4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828120851.07dbd1c52ec287ca169acee4@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:08:51PM -0700, Andrew Morton wrote:
> On Thu, 28 Aug 2014 14:33:30 -0400 "John W. Linville" <linville@tuxdriver.com> wrote:
> 
> > On Wed, Aug 20, 2014 at 12:42:41PM +0300, Andy Shevchenko wrote:
> > > The introduced function is a kind of opposite to string_unescape. We have
> > > several users of such functionality each of them created custom implementation.
> > > The series contains clean up of test suite, adding new call, and switching few
> > > users to use it via %*pE specifier.
> >
> > Any objections?  Do you (Andy) want me to merge this through the
> > wireless tree?
> > 
> 
> Who is this top-poster and what have you done with John?

:-)

> I was going to apply them yesterday but in [4/11] Andy said he plans on
> sending out a v5. (v4 actually?)

OK, I'll not worry any more about it.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
