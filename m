Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaJMKw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:52:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46954 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaJMKw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:52:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 77.231.195.203
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19cmOZxH1Vso6UrFA+90bif
Date: Mon, 13 Oct 2014 12:52:46 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Carles =?iso-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Regarding tx-nocache-copy in the Sheevaplug
Message-ID: <20141013105246.GD1972@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on the 7th of January 2014 ths patch was applied:
https://lkml.org/lkml/2014/1/7/307

[PATCH v2] net: Do not enable tx-nocache-copy by default
        
In the Sheevaplug (ARM Feroceon 88FR131 from Marvell) this made packets to be
sent corrupted. I think this machine has something special about the cache.

Enabling back this tx-nocache-copy (as it used to be before the patch) the
transfers work fine again. I think that most people, encountering this problem,
completely disable the tx offload instead of enabling back this setting.

Is this an ARM kernel problem regarding this platform?

Thank you,
Lluís
