Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423500Ab3CVWbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:31:43 -0400
Received: from magic.merlins.org ([209.81.13.136]:56523 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422648Ab3CVWbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:31:42 -0400
Date: Fri, 22 Mar 2013 15:31:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Cc: edvx1@systemanalysen.net
Subject: Re: Supporting SYSRQ on broken laptops like the thinkpad T530
Message-ID: <20130322223141.GQ12428@merlins.org>
References: <20130108230954.GN2044@merlins.org> <20130109023643.GA7066@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130109023643.GA7066@mobil.systemanalysen.net>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 3.1.5-core2-volpreempt-noide-hm64-20111218/Debian squeeze/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 03:36:44AM +0100, Roland Eggner wrote:
> On 2013-01-08 Tuesday at 15:09 -0800 Marc MERLIN wrote:
> > In its infinite wisdom, lenovo has removed the sysrq key on the latest
> > thinkpads, and replaced it with a stupid ALT+FN+S key combination, which
> > doesn't really work for doing sysrq from the console (nor do I know how the
> > genius who did that intended for SYSRQ-S to work).
> > http://forums.lenovo.com/t5/T400-T500-and-newer-T-series/T430-s-T530-Where-are-the-shortcut-function-keys-break-Pause-etc/ta-p/781749
> > 
> > I realize that one solution is to throw my laptop window at a suitable high
> > floorand replace it with one from a vendor that doesn't randomly remove keys
> > from the keyboard.
> > That said, I was wondering if there were other solutions, especially
> > considering that thinkpads used to be the better linux laptops.
> 
> My Dell “Precision M4500” notebook suffers similar (same?) problem.  So far 
> I could not find a solution better than this:  e.g. Alt-Fn-SysRq-s
> 
> press and hold Alt
> press and hold Fn
> press and leave F10|SysRq
> leave Fn
> press and leave s
> leave Alt

Just for the sake of the archives, turns out that on the lenovo T430 and T530 
you should ignore the Lenovo documentation I quoted above, and you can 
indeed use the PrtSc key between Right Alt and Right Ctrl, that key works
just fine for Sysrq.

I have no idea why Lenovo felt they had to document some complicated
alternate software sysrq with Fn+S

Anyway, hope this helps someone.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
