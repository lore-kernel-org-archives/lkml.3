Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3HTRiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:38:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41495 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751339Ab3HTRiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:38:17 -0400
Message-ID: <1377020294.2016.51.camel@joe-AO722>
Subject: Re: Why are BSD-licensed LZ4 symbols GPL exported?
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Yao <ryao@gentoo.org>, chanho.min@lge.com,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Tue, 20 Aug 2013 10:38:14 -0700
In-Reply-To: <20130820171148.GA17832@srcf.ucam.org>
References: <520D8C4C.7000704@gentoo.org>
	 <20130820171148.GA17832@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 18:11 +0100, Matthew Garrett wrote:
> On Thu, Aug 15, 2013 at 10:19:56PM -0400, Richard Yao wrote:
> > Why are the LZ4 symbols being GPL-exported when the LZ4 code is
> > BSD-licensed and no substantial changes appear to have been made when it
> > was merged?
> 
> EXPORT_SYMBOL_GPL is intended an indication that using a symbol is 
> likely to result in you producing a derived work of the kernel, and the 
> kernel as a whole is under the GPL. It has nothing to do with additional 
> licenses that individual pieces of code may be available under.

Maybe not.

http://www.ifross.org/en/artikel/ongoing-dispute-over-value-exportsymbolgpl-function


