Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3JWCWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:22:33 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42020 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab3JWCWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:22:32 -0400
Date: Wed, 23 Oct 2013 04:22:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ak@linux.intel.com, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 11/11] asmlinkage, wan/sbni: Make inline assembler
 symbols visible and assembler global
Message-ID: <20131023022230.GI29695@two.firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
 <1382458346-24811-12-git-send-email-andi@firstfloor.org>
 <20131022.135928.2040131908206663695.davem@davemloft.net>
 <20131023020955.GF29695@two.firstfloor.org>
 <CAGVrzcZ6xgp4TMgwDFJwz45m8narx0sHYAyM67HsD069tFg3BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcZ6xgp4TMgwDFJwz45m8narx0sHYAyM67HsD069tFg3BA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How about scheduling the WAN drivers for removal? Does anybody
> actually use them nowadays?

Perhaps at least the ISA devices? ISA hardware should be nearing
end of live by now.

Looking at the git log there doesn't seem to be any real changes,
other than tree sweeps or build fixes.

But I must admit I don't really know much about them.

-Andi
