Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbbADBlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 20:41:25 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34364 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbbADBlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 20:41:24 -0500
Date: Sun, 4 Jan 2015 02:41:19 +0100
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        pankaj.saraf@nektech.in, linux-kernel@vger.kernel.org,
        abbotti@mev.co.uk, jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: Re: [PATCH 0/5] *** SUBJECT HERE ***
Message-ID: <20150104014119.GE25819@t400>
References: <1420274187-6779-1-git-send-email-jkhasdev@gmail.com>
 <20150103164516.GB30268@kroah.com>
 <1420325674.9624.65.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420325674.9624.65.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03, Paul Bolle wrote:
> On Sat, 2015-01-03 at 08:45 -0800, Greg KH wrote:
> > On Sat, Jan 03, 2015 at 02:06:22PM +0530, jitendra kumar khasdev wrote:
> > > *** BLURB HERE ***
> > 
> > What blurb?  What subject?
> 
> jitendra used git-send-email to send this series. You'd expect
> git-send-email to die with an error if the cover letter, which it should
> see first, still contains these "*** [...] HERE ***" markers. What's the
> reason it doesn't do that?

git send-email does one thing and one thing only - sends stuff via
email. I do not see why it should parse the emails and decide whether to
complete the operation or break based on what is in the emails. It could
warn though however since the cover letter is a product of different
command introducing this logic would tightly couple those which is not
good.

I guess that it is better that people who send stuff acctually care what
they are sending. I mean that pretty quickly you learn to send the
series of patches first to yourself and review before it goes out to the
public.
 
> 
> Paul Bolle
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
