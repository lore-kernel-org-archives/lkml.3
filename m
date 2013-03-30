Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3C3Upd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 16:45:33 -0400
Received: from magic.merlins.org ([209.81.13.136]:36649 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3C3Upc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 16:45:32 -0400
Date: Sat, 30 Mar 2013 13:45:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        edvx1@systemanalysen.net
Subject: Re: Supporting SYSRQ on broken laptops like the thinkpad T530
Message-ID: <20130330204530.GF6093@merlins.org>
References: <20130108230954.GN2044@merlins.org>
 <20130109023643.GA7066@mobil.systemanalysen.net>
 <20130322223141.GQ12428@merlins.org>
 <20130330175628.GA28947@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130330175628.GA28947@amd.pavel.ucw.cz>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux
 3.7.8-amd64-preempt-20121226-fixwd/Debian wheezy/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-No-Run: Yes
X-Broken-Reverse-DNS: no host name for IP address 173.11.111.150
X-SA-Exim-Connect-IP: 173.11.111.150
X-SA-Exim-Mail-From: merlin@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 06:56:28PM +0100, Pavel Machek wrote:
> Sometimes it works, sometimes it does not. Don't blame lenovo for
> that.
> 
> Maybe it should be modified to take sysrq and _then_ key?
> 
> Or maybe we should use something like lshift+rshift+lalt+ralt+key?

It can't hurt to add alternatives like the one you suggested. They don't
have to be convenient, although the one you suggest takes 5 fingers at
the same time :)

Is there anything that uses
shift+ctrl+alt + key 
in userspace?

I checked enlightenment 17, they have crazy key bindings, but nothing
that uses all 3 modifier keys at the same time.
If that's not safe, feel free to add one or 2 more just to be safe.

Thanks for suggesting this.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
