Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab3ICCtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 22:49:04 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:42733 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759296Ab3ICCtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 22:49:02 -0400
Message-ID: <1378176973.32763.355.camel@haakon3.risingtidesystems.com>
Subject: Re: Linux 3.11
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 02 Sep 2013 19:56:13 -0700
In-Reply-To: <20130903021753.GA15457@thunk.org>
References: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
	 <1378161032.32763.341.camel@haakon3.risingtidesystems.com>
	 <CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
	 <5225234A.50407@roeck-us.net> <20130903021753.GA15457@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Mon, 2013-09-02 at 22:17 -0400, Theodore Ts'o wrote:
> On Mon, Sep 02, 2013 at 04:46:18PM -0700, Guenter Roeck wrote:
> > I don't think it has anything to do with linux-iscsi.org.
> > Possibly Nicholas' e-mail provider is not hosted in the US, meaning e-mail
> > sent through it can not be logged and examined by a certain US government agency.
> 
> Hardly.  mail.linux-iscsi.org is hosted by Rackspace, which is most
> certainly in the US.  There may be spammers using some of Rackspace
> subnets, which is much more likely to have something to be the issue.
> 
> I had a similar issue with thunk.org, which is hosted by Linode.  In
> my case, part of the problem was that I was that I moved my host to a
> different Linode datacenter (from Dallas to Atlanta), and I forgot to
> update my SPF record, so e-mails with an SMTP envelope address of
> tytso@thunk.org were getting a soft-fail.  (And e-mails with an SMTP
> return address of tytso@mit.edu but sent from imap.thunk.org were
> always getting a soft-fail, which would tend to increase the
> likelihood that if the e-mail tripped other hueristics, would cause it
> to be considered spam.)
> 
> Fixing my SPF record, and enabling DKIM (with a DKIM key published for
> thunk.org in DNS, and making sure that I always used an SMTP envelope
> return address of tytso@thunk.org, even if the RFC 822 from address
> stated tytso@mit.edu) fixed the spam false positive issues for me.
> 
> (Hint: installing and configuring OpenDKIM really isn't all that hard.
> I did it in less than an hour.)

<nod>, thanks for the additional information.

Enabling DKIM now, and just waiting for the TXT records to update to
verify.

--nab

