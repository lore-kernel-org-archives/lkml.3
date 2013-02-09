Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3BILg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 06:36:29 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:45639 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3BILg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 06:36:28 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH resend v3 3/3] kconfig: nconf:  add vi-style navigation keys
Date: Sat, 9 Feb 2013 12:36:23 +0100
User-Agent: KMail/1.13.5 (Linux/3.7.3-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org
References: <20130201182237.GA11098@mobil.systemanalysen.net> <201302090203.04055.yann.morin.1998@free.fr> <20130209050748.GB8891@mobil.systemanalysen.net>
In-Reply-To: <20130209050748.GB8891@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201302091236.23641.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rolland, All,

On Saturday 09 February 2013 Roland Eggner wrote:
> On 2013-02-09 Saturday at 02:03 +0100 Yann E. MORIN wrote:
> > On Friday 01 February 2013 Roland Eggner wrote:
> > > Add vi-style navigation keys, based on initial work by Dmitry Voytik.
> > 
> > As much I am a unconditional vim user, I doubt this is a sane idea to
> > include this, as it conflicts with the established UI that people expect,
> > especially since <h> is remapped and people already rely on <h> to provide
> > help, not do any other weird thing (like exiting the current submenu).
> 
> Having the most frequently used keys in the middle of the keyboard is 
> a professional computer usage pattern, not an anachronistic one.

I never said it was anachronistic. I just oppose this change as it conflicts
with a fundamental existing behavior (getting help) that people have come to
rely on.

> Regarding the <h>/<H> conflict:  My vision is to eliminate the need for help 
> keybindings <h> <?> at all by displaying the related help text beside the menu 
> permanently, similar to some graphical backends.  For terminals with 
> COLUMNS>=160 this should be rather easy to implement.  nouveaufb gives me by 
> default terminal with 274 columns, “retina” displays are entering the market 
> … the frequency of COLUMNS>=160 terminals probably will continue to grow.  While 
> staying compatible with COLUMNS=80, it seems reasonable to use the capabilities 
> of wider terminals, or what would you say?

How do you navigate up/down in the help text (when the terminal is not
high enought to display the entire help) if it is displayed at the same
time the menu entries are, yet without breaking the UI behavior people
expect?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
