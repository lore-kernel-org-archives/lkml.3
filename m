Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3AUAkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:40:52 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:16299 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3AUAku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:40:50 -0500
Date: Sun, 20 Jan 2013 19:40:49 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Borislav Petkov <bp@alien8.de>
Cc: David Dillow <dave@thedillows.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Message-ID: <861997288.94032.1358728848956.JavaMail.root@elliptictech.com>
In-Reply-To: <20130121003441.GA19447@pd.tnic>
Subject: Re: IPsec AH use of ahash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.112]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC24 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Borislav Petkov" <bp@alien8.de>
> To: "Steven Rostedt" <rostedt@goodmis.org>
> Cc: "Tom St Denis" <tstdenis@elliptictech.com>, "David Dillow" <dave@thedillows.org>, linux-kernel@vger.kernel.org,
> netdev@vger.kernel.org
> Sent: Sunday, 20 January, 2013 7:34:41 PM
> Subject: Re: IPsec AH use of ahash
> 
> On Sun, Jan 20, 2013 at 05:54:07PM -0500, Steven Rostedt wrote:
> > My God, you sound like a 2 year old.
> > 
> > Suck it up, and do the fixes. It's not the time you are worried
> > about,
> > as you most definitely spent more time bitching to everyone than it
> > would have taken you to clean up your work.
> 
> It's like you're reading my mind... :-)

The problem is for me to add the ()'s is a no brainer.

For me to re-write complete statements for coding style reasons means I have to actually go out and test it again.  In a proper IPsec lab that can take a couple of hours to make sure it's been run through its paces.  That's [among other things] the problem I have.  Re-writing perfectly good code because it doesn't meet coding "standards" that nobody else seems to match.

If you guys can't appreciate that I should just bow out of the discussion.  I didn't come here looking for a fight I came here to seek reason.

Tom
