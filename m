Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaIVAh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 20:37:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:18512 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbaIVAh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 20:37:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="389477524"
From: Andi Kleen <andi@firstfloor.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
References: <20140918135202.GA26038@khazad-dum.debian.net>
Date: Sun, 21 Sep 2014 17:37:24 -0700
In-Reply-To: <20140918135202.GA26038@khazad-dum.debian.net> (Henrique de
	Moraes Holschuh's message of "Thu, 18 Sep 2014 10:52:02 -0300")
Message-ID: <87tx40h4mz.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh <hmh@hmh.eng.br> writes:


>     And yes, this means we will kill support for microcode updates
>     outside of the initramfs/early-initramfs, at least in Debian,
>     and likely in Ubuntu.

You got it totally backwards. initramfs updating should handle this
microcode update just fine, as it happens before the kernel 
scans the cpuids. Just don't update it later.

Nothing else is needed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
