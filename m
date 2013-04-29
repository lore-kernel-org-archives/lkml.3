Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3D2PDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:03:20 -0400
Received: from nm26.access.bullet.mail.sp2.yahoo.com ([98.139.44.153]:46417
	"EHLO nm26.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496Ab3D2PDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:03:19 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 11:03:19 EDT
X-Yahoo-Newman-Id: 642546.94909.bm@smtp108.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YOE4CwcVM1lGN34zhLnxqE6vJZpw5bljf4b2Cn8eCPZTtnj
 cmiqLoOMss0lMs.G8t.nPW0Lats0aXJMNcV6Zv.VkeZv6NoUxTnsTvYytUJO
 AVeedLsXc0wJzqPWqB2fzYNwYjVasANHi55bDT2dycTmrECWVYSzup3CiVH5
 MHHopg.pzeSkVat.wuTSN55usFUiYH5lCrVTcoS9ZjZgIga4DBPgJWtIBRSR
 1nFkpD_2Z664BaEHGcZkKwGy8ZTYsncvciovN5hdWk.fLZceHne4a82okvCM
 LXZgScil.fmv7TbXCbt_wL.6CGC2r5ygMf4_ORS7hHaGMNGUf.vgy7Sp98wg
 gV.mdPsQZWRLFPGIncgYgH76JvdKDhib8eRRjWfIhqd9mAPmIGajzO8mQskY
 cboZ7YUI.A4hlaD_TIhUxt.Mn8pnrlEz.dhOi4BIhnvzKFg6YJhSHwgMsJ0B
 Yx94GFvZep7aeEPfoE7pQjewW0ejQZDCwfTU-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp108.sbc.mail.ne1.yahoo.com with SMTP; 29 Apr 2013 08:00:37 -0700 PDT
Date: Mon, 29 Apr 2013 08:00:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: Re: mfd: Core driver for Winbond chips
Message-ID: <20130429150037.GB7967@roeck-us.net>
References: <20130322205258.GE7867@spo001.leaseweb.com>
 <20130323002810.GA26245@roeck-us.net>
 <20130323174914.GA21563@roeck-us.net>
 <20130409093700.GM24058@zurbaran>
 <20130409113639.GA8731@roeck-us.net>
 <20130409114544.GD7867@spo001.leaseweb.com>
 <20130409161838.GB27050@roeck-us.net>
 <20130409173115.GF7867@spo001.leaseweb.com>
 <20130410003632.GA25712@roeck-us.net>
 <20130410205926.GB14155@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410205926.GB14155@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:59:26PM +0200, Wim Van Sebroeck wrote:
> Hi Guenter,
> 
> > > I looked at commit 8b6d043b7ee2d1b819dc833d677ea2aead71a0c0 (which implements
> > > request_muxed_region). You indeed need some extra code for loading the lowl-level
> > > mfd driver. So I am also in favour of the exported function.
> > > 
> > So which way should we go ? Take your driver as a starting point or mine ?
> > 
> > One thing I'll want to add is support for both superio regions, as I have a use
> > case for it.
> 
> I'll come back on this tomorrow. It's going to be a merge of your and my code anyway.
> 
> I agree it would be nice to add also hwmon + wdog support in it from the start.
> 
Hi Wim,

looks like you are busy. Want me to take another stake at it and do the merge ?

Thanks,
Guenter
