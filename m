Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3DZMLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:11:08 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:59341 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3DZMLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:11:06 -0400
Date: Fri, 26 Apr 2013 14:11:00 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sam Ravnborg <sam@ravnborg.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 6/8] kconfig: fix randomising choice entries in presence
 of KCONFIG_ALLCONFIG
Message-ID: <20130426121100.GA5791@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
 <422c809f03f043d0950d8362214818e956a9daee.1366841993.git.yann.morin.1998@free.fr>
 <6079984.JVoK3fHgsy@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6079984.JVoK3fHgsy@wuerfel>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, All,

On Fri, Apr 26, 2013 at 02:05:37PM +0200, Arnd Bergmann wrote:
> On Thursday 25 April 2013 00:29:53 Yann E. MORIN wrote:
> > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > 
> > Currently, randconfig does randomise choice entries, unless KCONFIG_ALLCONFIG
> > is specified.
> > 
> > For example, given those two files (Thomas' test-case):
> 
> This patch has made it into linux-next today, and while I agree with
> the basic idea, it seems to cause regressions for me.

Yes, this has already been noticed. Thanks for the report.

So far, we have a plan B (which is to revert that patch). I'll work on
plan A when I'm back home after work (GMT+2 here, so in about 5h from
now).

Sorry for the annoyance...

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
