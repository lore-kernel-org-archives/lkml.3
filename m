Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaCIIIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:08:44 -0400
Received: from www84.your-server.de ([213.133.104.84]:38671 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaCIIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:08:36 -0400
Message-ID: <1394352497.1002.4.camel@wall-e.seibold.net>
Subject: Re: [x86, vdso]  BUG: unable to handle kernel paging request at
 d34bd000
From: Stefani Seibold <stefani@seibold.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2014 09:08:17 +0100
In-Reply-To: <20140307234411.GA14886@localhost>
References: <20140307013833.GD8427@localhost>
	 <1394182034.21684.6.camel@wall-e.seibold.net>
	 <20140307091515.GA8888@localhost>
	 <1394186248.28066.42.camel@wall-e.seibold.net>
	 <20140307234411.GA14886@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 08.03.2014, 07:44 +0800 schrieb Fengguang Wu:
> Hi Stefani,
> 
> > So i tried my best, but without support it is impossible to find all
> > issues. But mostly what i get was bureaucracy afflictions
> > 
> > I complied, but now it is time to help finding the issues. And not only
> > do a complain, sit back and wait.
> 
> I feel sorry if that's what you perceived. But I'm just submitting
> test results rather than complaining. I should actually be glad if my
> test system catches more bugs. ;-) And there is no way for me to sit
> back - I'm actually overloaded. Yesterday I wrote 63 emails, which is
> one per 10 minutes _assuming_ I'm working 8hours. You can imagine the
> works required behind all these emails.
> 

This was not addressed to you, it was addressed to the x86 intel kernel
developers to do more testing, since this piece of code has so many side
effects. I apologizes this miss understanding.

- Stefani

