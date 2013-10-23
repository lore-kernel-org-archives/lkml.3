Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab3JWG2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 02:28:46 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:50228 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3JWG2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 02:28:45 -0400
Date: Wed, 23 Oct 2013 08:28:05 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ak@linux.intel.com, netdev <netdev@vger.kernel.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 11/11] asmlinkage, wan/sbni: Make inline assembler
 symbols visible and assembler global
Message-ID: <20131023062805.GA23446@electric-eye.fr.zoreil.com>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
 <1382458346-24811-12-git-send-email-andi@firstfloor.org>
 <20131022.135928.2040131908206663695.davem@davemloft.net>
 <20131023020955.GF29695@two.firstfloor.org>
 <CAGVrzcZ6xgp4TMgwDFJwz45m8narx0sHYAyM67HsD069tFg3BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcZ6xgp4TMgwDFJwz45m8narx0sHYAyM67HsD069tFg3BA@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Fainelli <f.fainelli@gmail.com> :
[...]
> How about scheduling the WAN drivers for removal? Does anybody
> actually use them nowadays?

There is still some interest in WAN drivers, see Christophe Leroy
posting on 2013/10/13 "[PATCH] WAN: Adding support for Infineon PEF2256
E1 chipset" (buggy but it's a different topic).

-- 
Ueimor
