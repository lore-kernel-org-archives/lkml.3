Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab3AOQvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:51:50 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:50580 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3AOQvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:51:50 -0500
Date: Tue, 15 Jan 2013 11:51:48 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: steffen.klassert@secunet.com
Cc: herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Message-ID: <528051367.70594.1358268708738.JavaMail.root@elliptictech.com>
Subject: IPsec AH use of ahash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.111]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC24 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The AH4/6 code uses ahash to perform the MAC calculation but this precludes the availability of GMAC to the user.  Are there any plans to port the AH code over to the aead API so that it can use potentially any algo available to the user?

Tom St Denis
