Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaHSNPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:15:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:17422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaHSNP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:15:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,894,1400050800"; 
   d="scan'208";a="560551105"
From: Andi Kleen <andi@firstfloor.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Overriding -Werror
References: <20140814222119.GD18411@ld-irv-0074>
Date: Tue, 19 Aug 2014 06:15:07 -0700
In-Reply-To: <20140814222119.GD18411@ld-irv-0074> (Brian Norris's message of
	"Thu, 14 Aug 2014 15:21:19 -0700")
Message-ID: <87ppfwmxic.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Norris <computersforpeace@gmail.com> writes:
>
> 4. better ideas?

Just send patches to remove -Werror in all architectures
as a tree sweep (and anywhere else where someone misguided add it)

Having -Werror anywhere in a shipping release is just plainly a bug,
as it makes it often impossible to build on newer gcc versions.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
