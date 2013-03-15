Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3COOQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 10:16:35 -0400
Received: from fallback5.mail.ru ([94.100.176.59]:39456 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3COOQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 10:16:33 -0400
Subject: Re: [PATCH] phy: Elimination the forced speed reduction algorithm.
From: Kirill Kapranov <kapranoff@inbox.ru>
Reply-To: kapranoff@inbox.ru
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, bhutchings@solarflare.com, peppe.cavallaro@st.com,
        joe@perches.com, bruce.w.allan@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20130315.083524.1244515166306242265.davem@davemloft.net>
References: <1363257652-8255-1-git-send-email-kapranoff@inbox.ru>
	 <20130315.083524.1244515166306242265.davem@davemloft.net>
Content-Type: text/plain; charset="KOI8-R"
Organization: NITA, LLC
Date: Fri, 15 Mar 2013 18:15:53 +0400
Message-ID: <1363356953.2890.13.camel@kkk.nita.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


15/03/2013 08:35 -0400, David Miller wrote:
> From: Kirill Kapranov <kapranoff@inbox.ru>
> Date: Thu, 14 Mar 2013 14:40:52 +0400
> 
> > @@ -867,7 +821,6 @@ void phy_state_machine(struct work_struct *work)
> >  				netif_carrier_on(phydev->attached_dev);
> >  			} else {
> >  				if (0 == phydev->link_timeout--) {
> > -					phy_force_reduction(phydev);
> >  					needs_aneg = 1;
> >  				}
> 
> This is not a single-statement basic block, and therefore you
> should remove the surrounding braces.

Thank You, the excess braces will be removed.

