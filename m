Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab3LaSVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 13:21:04 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52857 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753937Ab3LaSVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 13:21:02 -0500
Date: Tue, 31 Dec 2013 18:14:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Gerhard Sittig <gsi@denx.de>
Cc: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [ARM] Fix kernel compile error: drivers/crypto/ixp4xx_crypto.c.
Message-ID: <20131231181427.GE16456@n2100.arm.linux.org.uk>
References: <m3d2kduwd7.fsf@t19.piap.pl> <20131231134820.GS8064@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131231134820.GS8064@book.gsilab.sittig.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please get rid of your Mail-Followup-To: header:

Mail-Followup-To: Krzysztof Hałasa <khalasa@piap.pl>,                           
        lkml <linux-kernel@vger.kernel.org>,                                    
        linux-arm-kernel@lists.infradead.org,                                   
        Russell King <rmk+kernel@arm.linux.org.uk>,                             
        Christian Hohnstaedt <chohnstaedt@innominate.com>,                      
        Herbert Xu <herbert@gondor.apana.org.au>                                
User-Agent: Mutt/1.5.21 (2010-09-15)                                            

It causes all recipients following the thread to be moved into the To:
header when someone replies to one of your messages, which is deemed to
be anti-social.  You can kill this header by adding:

	set followup_to=no

to your .muttrc file.

Thanks.
