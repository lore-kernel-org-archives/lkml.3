Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaD1DYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 23:24:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:9980 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaD1DYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 23:24:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,940,1389772800"; 
   d="scan'208";a="522146720"
From: Andi Kleen <andi@firstfloor.org>
To: Geyslan =?utf-8?Q?Greg=C3=B3rio?= Bem <geyslan@gmail.com>
Cc: kernel-br <kernel-br@googlegroups.com>,
        "open list\:FILESYSTEMS \(VFS...\)\, linux-kernel\@vger.kernel.org
	\(open list\)" <linux-fsdevel@vger.kernel.org>,
        kernelnewbies <Kernelnewbies@kernelnewbies.org>,
        LKML <linux-kernel@vger.kernel.org>, jikos@jikos.cz,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Kernel-BR] Re: [RFC] Only a.out QMAGIC format is working
References: <CAGG-pURwpGGFyCp-htffegnVhf1VwAke1XPrC+GirXKy-HhqJA@mail.gmail.com>
	<20140419161552.GB27776@amd.pavel.ucw.cz>
	<CAGG-pUQ5+dv566KZK2hbQENXSEPaY5k5fapgnLUE0jTv1ihPMg@mail.gmail.com>
	<20140420114501.GA12135@amd.pavel.ucw.cz>
	<CAGG-pUSyxxa=vyNBDABf8J1BNuzY8UTA9g3r35g2O4=XK1OYXA@mail.gmail.com>
Date: Sun, 27 Apr 2014 20:23:58 -0700
In-Reply-To: <CAGG-pUSyxxa=vyNBDABf8J1BNuzY8UTA9g3r35g2O4=XK1OYXA@mail.gmail.com>
	("Geyslan =?utf-8?Q?Greg=C3=B3rio?= Bem"'s message of "Sun, 20 Apr 2014
 09:13:35
	-0300")
Message-ID: <8738gym90x.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geyslan Gregório Bem <geyslan@gmail.com> writes:
>     
>     There should be chance to fix it.
>     
> I think it too.

If it's randomization the following could help:

echo 0 > /proc/sys/kernel/randomize_va_space

Does it?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
