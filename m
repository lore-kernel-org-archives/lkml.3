Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3AUVVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:21:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48036 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab3AUVVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:21:30 -0500
Date: Mon, 21 Jan 2013 22:21:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        "David S. Miller" <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Kay Sievers <kay@vrfy.org>,
        linux-ia64@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, sparclinux@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v4 00/13] Add gdb python scripts as kernel debugging helpers
Message-ID: <20130121212129.GR30577@one.firstfloor.org>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> And this is a tutorial for the gdb extension using QEMU/KVM as target
> platform:

Can you add the tutorial as a file in Documentation? 
Other than that everything looks good to me.

-Andi
