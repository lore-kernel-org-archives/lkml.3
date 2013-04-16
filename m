Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981Ab3DPQie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:38:34 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36102 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964962Ab3DPQib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:38:31 -0400
Date: Tue, 16 Apr 2013 18:38:25 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: Benjamin Poirier <bpoirier@suse.de>, Wang YanQing <udknight@gmail.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] menuconfig: Fix memory leak introduced by jump keys
 feature
Message-ID: <20130416163825.GA11398@free.fr>
References: <1366035231-24370-1-git-send-email-bpoirier@suse.de>
 <20130415215432.GB12519@free.fr>
 <516D0A1B.1010704@suse.cz>
 <516D1609.6020500@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516D1609.6020500@suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On Tue, Apr 16, 2013 at 11:12:41AM +0200, Michal Marek wrote:
> > On 15.4.2013 23:54, Yann E. MORIN wrote:
> >> So, unless Michal really wants to pull this one and push it to Linus
> >> before he cuts v3.9 final, I'll merge this later in my -for-next branch.
> BTW, in you are going to rebase the commit, it would be good idea to add
> Cc: <stable@vger.kernel.org> to the changelog.

Yes sure.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
