Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab3DANwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:52:43 -0400
Received: from smtp23.mail.ru ([94.100.176.176]:46054 "EHLO smtp23.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850Ab3DANwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:52:41 -0400
Subject: Re: [PATCH] phy: Elimination the forced speed reduction algorithm.
From: Kirill Kapranov <kapranoff@inbox.ru>
Reply-To: kapranoff@inbox.ru
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, bhutchings@solarflare.com, peppe.cavallaro@st.com,
        joe@perches.com, bruce.w.allan@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20130329.143808.647821389772332250.davem@davemloft.net>
References: <1364304872-6408-1-git-send-email-kapranoff@inbox.ru>
	 <20130329.143808.647821389772332250.davem@davemloft.net>
Content-Type: text/plain; charset="KOI8-R"
Organization: NITA, LLC
Date: Mon, 01 Apr 2013 17:51:44 +0400
Message-ID: <1364824304.6276.28.camel@kkk.nita.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fri, 29/03/2013 14:38 -0400, David Miller пишет:
> Why are you posting this again?  I've applied your patch 3 days
> ago.

oops...
The last letter I sent was a coding style correction -- removing
trailing whitespace in response to remark of Tue, 26 Mar 2013 12:59:13
-0400 (EDT)  by David Miller:
> 
> 
> > -                                     phy_force_reduction(phydev);
> > +                             if (0 == phydev->link_timeout--) 
>                                                                 ^^^^
> Trailing whitespace, please remove.

I sent it  Wed, 27 Mar 2013 15:16:13 +0400

After receiving confirmation (Wed, 27 Mar 2013 13:11:02 -0400 (EDT))

> Applied.

from David Miller, I haven't sent any post.


