Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3D0PTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 11:19:07 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39001 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3D0PTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 11:19:04 -0400
Date: Sat, 27 Apr 2013 17:18:57 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: sedat.dilek@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 26
Message-ID: <20130427151857.GA3355@free.fr>
References: <CA+icZUWt_W5FUQgQ2TFoQU0df+sAbxZZE8AcD16T3f_fiTD9DQ@mail.gmail.com>
 <517A4FC1.3070605@suse.cz>
 <20130426100435.GA28733@sepie.suse.cz>
 <CA+icZUVOfB2JuL1xh1EO1hTP_eOkntYFKsUJ0Zp6VZqn09NABA@mail.gmail.com>
 <CA+icZUWNVEsiTs6u_2R9krb45ub4t-pZj_VEPRmrX2c4DzwfmA@mail.gmail.com>
 <CA+icZUXSsqN1iE3ttQakvpZqG-oOL9NR6RMUezB7LGeUw3d00Q@mail.gmail.com>
 <517A6033.5060103@suse.cz>
 <517A615D.9020400@suse.cz>
 <20130426220131.GC5100@free.fr>
 <517B762D.8030409@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517B762D.8030409@suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On Sat, Apr 27, 2013 at 08:54:37AM +0200, Michal Marek wrote:
> That (silent)oldconfig with stdin redirection throws an error if it
> encounters a new option is expected and correct. The bug here is that
> _normal_ oldconfig run apparently does not set all the options. I.e.
> 
> $ yes "" | make oldconfig; make silentoldconfig </dev/null
> 
> should always pass.

Ah, OK, now I got it. Thank you for the explanations.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
