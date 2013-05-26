Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab3EZDT5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 23:19:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62155 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879Ab3EZDT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 23:19:56 -0400
Message-ID: <1369538388.5893.15.camel@marge.simpson.net>
Subject: Re: [PATCH v2] ipc/sem.c: fix lockup, restore FIFO behavior
From: Mike Galbraith <bitbucket@online.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 May 2013 05:19:48 +0200
In-Reply-To: <51A11851.2010303@colorfullife.com>
References: <1369495011-2586-1-git-send-email-manfred@colorfullife.com>
	 <51A0FB23.3050301@redhat.com>
	 <1369506721.2065.10.camel@buesod1.americas.hpqcorp.net>
	 <51A11851.2010303@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:KlJ/pq4Al2cDFh/XfYrt2J3IrqRQdizYD6vcTmXQTIk
 OrZVt/XrGFTmEUI4m7lv7LGDmKbqz8uBccOGgjh/ZsRWbt+n/0
 RVCCf50CGoTPznxVx0MKUjzms5TCeJu+e4ZtxVV8jxzoIWGELn
 NesV2XPvL1RMqBvMWPNFD+8sA9C9J4HTDKIDkHT97x6elhWIoo
 Aef4Z8iq8IoRAq/4/419/B4o9l3w9O83umSRznap0qZwkC7RBa
 jydi7VvUXQCxK3N01yYKpyCs3y8zyWa+KQRbVoZpYL0Z6nP3FQ
 r4yE5ajernILbqQHqXonEq5CYfbARgjM6GvzZr6F6smT1F0jkr
 mkdUkB7l8KlxVKb2wRHrZgYaf1i+eYuJAwuCV7US0pptqdYorE
 prU6GcwzpmRiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-05-25 at 22:00 +0200, Manfred Spraul wrote:

> P.S.:
> Btw, I found some code that uses a semop with 2 ops:
> http://publib.boulder.ibm.com/infocenter/iseries/v5r3/index.jsp?topic=%2Fapis%2Fapiexusmem.htm

I recently analyzed rt traces containing 9 ops.

-Mike

