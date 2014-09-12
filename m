Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaILEKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:10:00 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52348 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaILEJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:09:58 -0400
MIME-Version: 1.0
In-Reply-To: <1410444957.9942.3.camel@joe-AO725>
References: <20140908181524.GA11839@www.outflux.net>
	<20140910155219.3d21aef2df8b1754a736cc1a@linux-foundation.org>
	<CAMuHMdUvBdEKCYezARJ8PvuQPQbi+Wq-fwO+Z2cxYXOtVzp5GQ@mail.gmail.com>
	<1410444957.9942.3.camel@joe-AO725>
Date: Fri, 12 Sep 2014 13:09:57 +0900
Message-ID: <CALLJCT1_pB8pEHCCEnNzfQrRR16dGD3rdfjAt40sHXzTBbdEXQ@mail.gmail.com>
Subject: Re: [PATCH v2] checkpatch: look for common misspellings
From: Masanari Iida <standby24x7@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        linux-doc <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Talking about codespell,  it detected 76 "informations" in 3.17-rc4.
" grep -R informations * |wc -l"  found 120 typos.
Test with "occured",  codespell found 46,  grep found 110.
Test with "reseting" case,  codespell found 21, grep found 26.

So I expect about half of the incoming typos will be detected by the tool,
and be fixed.
Masanari
