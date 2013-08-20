Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3HTVqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:46:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51725 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751408Ab3HTVqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:46:35 -0400
Message-ID: <1377035193.2016.81.camel@joe-AO722>
Subject: Re: Why are BSD-licensed LZ4 symbols GPL exported?
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Richard Yao <ryao@gentoo.org>,
        chanho.min@lge.com,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Tue, 20 Aug 2013 14:46:33 -0700
In-Reply-To: <1377034669.2737.83@driftwood>
References: <520D8C4C.7000704@gentoo.org>
	 <20130820171148.GA17832@srcf.ucam.org> <1377020294.2016.51.camel@joe-AO722>
	 <1377034669.2737.83@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 16:37 -0500, Rob Landley wrote:
> On 08/20/2013 12:38:14 PM, Joe Perches wrote:
> > On Tue, 2013-08-20 at 18:11 +0100, Matthew Garrett wrote:
> > > On Thu, Aug 15, 2013 at 10:19:56PM -0400, Richard Yao wrote:
> > > > Why are the LZ4 symbols being GPL-exported when the LZ4 code is
> > > > BSD-licensed and no substantial changes appear to have been made  
> > when it
> > > > was merged?
> > >
> > > EXPORT_SYMBOL_GPL is intended an indication that using a symbol is
> > > likely to result in you producing a derived work of the kernel, and  
> > the
> > > kernel as a whole is under the GPL. It has nothing to do with  
> > additional
> > > licenses that individual pieces of code may be available under.
> > 
> > Maybe not.
> > http://www.ifross.org/en/artikel/ongoing-dispute-over-value-exportsymbolgpl-function
> 
> Kernel developers: "We're making symbols that we, as the creators of  
> this project, don't think you can use without the result being a  
> derived work".
> 
> Lawyers: "we're prepared to argue over the definitions of 'that', 'as',  
> 'of', 'this', 'use', and 'the', as long as we're paid by the hour."

Law is certainly a, umm, useful occupation.

> This random speculation outside of a courtroom actually capable of  
> setting precedent strikes you as relevant for what reason?

Because your declarative statement that EXPORT_SYMBOL_GPL is
"intended [as] an indication that using [the] symbol is likely
to result..." is incomplete.

There are competing histories as to what EXPORT_SYMBOL_GPL
was intended to do.


