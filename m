Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaAAMS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 07:18:29 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:33031 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaAAMS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 07:18:27 -0500
X-Auth-Info: B/SvLCIXNCxc/omOhfCMQOZ9sQ5xJwsIWQ4dkn4lNts=
Date: Wed, 1 Jan 2014 13:18:22 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [ARM] Fix kernel compile error: drivers/crypto/ixp4xx_crypto.c.
Message-ID: <20140101121822.GA20094@book.gsilab.sittig.org>
References: <m3d2kduwd7.fsf@t19.piap.pl>
 <20131231134820.GS8064@book.gsilab.sittig.org>
 <20131231181427.GE16456@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20131231181427.GE16456@n2100.arm.linux.org.uk>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 18:14 +0000, Russell King - ARM Linux wrote:
> 
> Please get rid of your Mail-Followup-To: header:
> 
> Mail-Followup-To: Krzysztof Hałasa <khalasa@piap.pl>,                           
>         lkml <linux-kernel@vger.kernel.org>,                                    
>         linux-arm-kernel@lists.infradead.org,                                   
>         Russell King <rmk+kernel@arm.linux.org.uk>,                             
>         Christian Hohnstaedt <chohnstaedt@innominate.com>,                      
>         Herbert Xu <herbert@gondor.apana.org.au>                                
> User-Agent: Mutt/1.5.21 (2010-09-15)                                            
> 
> It causes all recipients following the thread to be moved into the To:
> header when someone replies to one of your messages, which is deemed to
> be anti-social.  You can kill this header by adding:
> 
> 	set followup_to=no
> 
> to your .muttrc file.

Thank you for telling me, I was not aware.  Had no MFT related
setting in my config, learned from the manual that $followup_to
defaults to yes, have turned it off now.  Other mutt users may
want to check as well.  Happy new year! :)


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
