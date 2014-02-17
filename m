Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaBQW7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:59:03 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:44418 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaBQW7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:59:01 -0500
MIME-Version: 1.0
In-Reply-To: <20140214043235.GA21999@linux.vnet.ibm.com>
References: <52F88C16.70204@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com>
	<52F8C556.6090006@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402101333160.15624@chino.kir.corp.google.com>
	<52FC6F2A.30905@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402130003320.11689@chino.kir.corp.google.com>
	<52FC98A6.1000701@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402131416430.13899@chino.kir.corp.google.com>
	<20140214001438.GB1651@linux.vnet.ibm.com>
	<CA+55aFwH8BqyLSqyLL7g-08nOtnOrJ9vKj4ebiSqrxc5ooEjLw@mail.gmail.com>
	<20140214043235.GA21999@linux.vnet.ibm.com>
Date: Mon, 17 Feb 2014 14:59:00 -0800
X-Google-Sender-Auth: _n2NkRIVFGbNWUSlV7-zWgTrbgs
Message-ID: <CA+55aFzZh6nzGtwFSeu05q_2oPQsueUjD_LLz5WSAgHbpyMrvg@mail.gmail.com>
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 8:32 PM, Nishanth Aravamudan
<nacc@linux.vnet.ibm.com> wrote:
>
> Agreed that for the readahead case the above is probably more than
> sufficient.
>
> Apologies for hijacking the thread, my comments below were purely about
> the memoryless node support, not about readahead specifically.

Ok, no problem. I just wanted to make sure that we're not going down
some fragile rats nest just for something silly that wasn't worth it.

                 Linus
