Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936093Ab3DPRU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:20:27 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62982 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935825Ab3DPRU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:20:26 -0400
Date: Tue, 16 Apr 2013 19:20:20 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: Michal Marek <mmarek@suse.cz>, Wang YanQing <udknight@gmail.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] menuconfig: Add "breadcrumbs" navigation aid
Message-ID: <20130416172020.GB11398@free.fr>
References: <20130415213958.GA12519@free.fr>
 <1366121243-966-1-git-send-email-bpoirier@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366121243-966-1-git-send-email-bpoirier@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin, All,

On Tue, Apr 16, 2013 at 10:07:23AM -0400, Benjamin Poirier wrote:
> Displays a trail of the menu entries used to get to the current menu.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
> Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> [yann.morin.1998@free.fr: small, trivial code re-ordering]
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> ---
> 
> Indeed Yann, we can even remove one wmove() and one level of indentation in
> dialog_clear().
> 
> I'm not sure who's pulling from who and where patches are going,

It would be me aggregating all kconfig-related changes in my repo during
the devel phase, and then sending Michal a pull-request slightly before
each merge window (which should be real-soon-now...).

> but this would supersede what's in yem-kconfig-for-next now.

OK, I've reintegrated this here. Thank you!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
