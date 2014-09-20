Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbaITSfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 14:35:16 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50104 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbaITSfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 14:35:14 -0400
Date: Sat, 20 Sep 2014 19:35:09 +0100
From: Grzegorz Swirski <grzegorz@swirski.name>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: gregkh@linuxfoundation.org, josh@joshtriplett.org,
        stankus.modestas@gmail.com, vitaly.osipov@gmail.com,
        Johannes.Stadlinger@fau.de, himangi774@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wlan-ng: remove unused 'result' var
Message-ID: <20140920183509.GA4515@computer.home.gateway>
References: <1411211351-4207-1-git-send-email-grzegorz@swirski.name>
 <20140920181635.GA2379@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140920181635.GA2379@sudip-PC>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> you have not mentioned any commit log

Sorry. Patch against linux-next, commit
d7cf2b3139909a354a71e2885c942e21a60ea062

> > @@ -734,11 +732,10 @@ static int prism2mib_priv(struct mibrec *mib,
> >  				wpa.datalen = cpu_to_le16(pstr->len);
> >  				memcpy(wpa.data, pstr->data, pstr->len);
> >  
> > -				result =
> > -				    hfa384x_drvr_setconfig(hw,
> > -						   HFA384x_RID_CNFWPADATA,
> > -						   (u8 *) &wpa,
> > -						   sizeof(wpa));
> > +				hfa384x_drvr_setconfig(hw,
> > +						       HFA384x_RID_CNFWPADATA,
> > +						       (u8 *) &wpa,
> if you check your patch with --strict option then you will see one warning here.

There are many styling offences in this file. I didn't want to include
unrelated changes in one patch.

Grzegorz Swirski.
