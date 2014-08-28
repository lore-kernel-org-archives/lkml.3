Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaH1TIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:08:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaH1TIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:08:53 -0400
Date: Thu, 28 Aug 2014 12:08:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3 00/11] lib: introduce string_escape_mem and %*pE
 specifier
Message-Id: <20140828120851.07dbd1c52ec287ca169acee4@linux-foundation.org>
In-Reply-To: <20140828183330.GM13758@tuxdriver.com>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20140828183330.GM13758@tuxdriver.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014 14:33:30 -0400 "John W. Linville" <linville@tuxdriver.com> wrote:

> On Wed, Aug 20, 2014 at 12:42:41PM +0300, Andy Shevchenko wrote:
> > The introduced function is a kind of opposite to string_unescape. We have
> > several users of such functionality each of them created custom implementation.
> > The series contains clean up of test suite, adding new call, and switching few
> > users to use it via %*pE specifier.
>
> Any objections?  Do you (Andy) want me to merge this through the
> wireless tree?
> 

Who is this top-poster and what have you done with John?

I was going to apply them yesterday but in [4/11] Andy said he plans on
sending out a v5. (v4 actually?)

