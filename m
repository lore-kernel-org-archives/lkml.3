Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbbAGMXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:23:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbbAGMXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:23:00 -0500
Date: Wed, 7 Jan 2015 13:22:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Giel van Schijndel <me@mortis.eu>
Cc: linux-kernel@vger.kernel.org, Armin Schindler <mac@melware.de>,
        Karsten Keil <isdn@linux-pingi.de>,
        "open list:ISDN SUBSYSTEM" <netdev@vger.kernel.org>
Subject: Re: [PATCH] Fix NUL (\0 or \x00) specification in string
Message-ID: <20150107122258.GG24104@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Giel van Schijndel <me@mortis.eu>,
	linux-kernel@vger.kernel.org, Armin Schindler <mac@melware.de>,
	Karsten Keil <isdn@linux-pingi.de>,
	"open list:ISDN SUBSYSTEM" <netdev@vger.kernel.org>
References: <1420394722-20197-1-git-send-email-me@mortis.eu>
 <20150105150026.GG6114@twin.jikos.cz>
 <20150106192804.GL4806@salidar.dom.custoft.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106192804.GL4806@salidar.dom.custoft.eu>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 08:28:04PM +0100, Giel van Schijndel wrote:
> On Mon, Jan 05, 2015 at 16:00:26 +0100, David Sterba wrote:
> > I'm replying to all your recent patches here as they are fixing things
> > reported in http://www.viva64.com/en/b/0299/ . I'ts a good practice to
> > give the credit the reporter.
> > 
> > The blogpost also contains analyses of the issues so it could help
> > reviewing the patches.
> 
> I guess you suggest I use a 'Reported-(at|by)' line?

A link in the changelog would be enough IMHO.

> Would something like the below suffice? I found similar log entries in the
> commit log, e.g. bf3204cb, except that those add an e-mail address for
> the reporters, which I don't think is necessary in this case.

If you don't have the emails, then rather do not use reported-by.
