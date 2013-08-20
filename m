Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab3HTVhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:37:53 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:54885 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3HTVhw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:37:52 -0400
Date: Tue, 20 Aug 2013 16:37:49 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Why are BSD-licensed LZ4 symbols GPL exported?
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Richard Yao <ryao@gentoo.org>,
        chanho.min@lge.com,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <520D8C4C.7000704@gentoo.org>
	<20130820171148.GA17832@srcf.ucam.org> <1377020294.2016.51.camel@joe-AO722>
In-Reply-To: <1377020294.2016.51.camel@joe-AO722> (from joe@perches.com on
	Tue Aug 20 12:38:14 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1377034669.2737.83@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 12:38:14 PM, Joe Perches wrote:
> On Tue, 2013-08-20 at 18:11 +0100, Matthew Garrett wrote:
> > On Thu, Aug 15, 2013 at 10:19:56PM -0400, Richard Yao wrote:
> > > Why are the LZ4 symbols being GPL-exported when the LZ4 code is
> > > BSD-licensed and no substantial changes appear to have been made  
> when it
> > > was merged?
> >
> > EXPORT_SYMBOL_GPL is intended an indication that using a symbol is
> > likely to result in you producing a derived work of the kernel, and  
> the
> > kernel as a whole is under the GPL. It has nothing to do with  
> additional
> > licenses that individual pieces of code may be available under.
> 
> Maybe not.
> 
> http://www.ifross.org/en/artikel/ongoing-dispute-over-value-exportsymbolgpl-function

Kernel developers: "We're making symbols that we, as the creators of  
this project, don't think you can use without the result being a  
derived work".

Lawyers: "we're prepared to argue over the definitions of 'that', 'as',  
'of', 'this', 'use', and 'the', as long as we're paid by the hour."

This random speculation outside of a courtroom actually capable of  
setting precedent strikes you as relevant for what reason?

Rob