Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaCQVpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:45:47 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36094 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaCQVpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:45:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJuUf4dwFqAZJgqRduw_oEN=H-FUh8vEDuThnhp9MPxKg@mail.gmail.com>
References: <20140312132441.GA29079@shuo-gentoo>
	<20140312133403.GB29079@shuo-gentoo>
	<CAGXu5jJuUf4dwFqAZJgqRduw_oEN=H-FUh8vEDuThnhp9MPxKg@mail.gmail.com>
Date: Mon, 17 Mar 2014 14:45:45 -0700
Message-ID: <CA+8MBb+-R8aWFRrCnvAnY2mbNnmF31wKf+D5_cUuNagNRb0bDA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pstore: fix memory leak when decompress using big_oops_buf
From: Tony Luck <tony.luck@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Liu Shuo <shuox.liu@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Zhang Yanmin <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok - applied the original two that Andrew had allready taken into -mm, plus
these four to my "next" branch.  So I have these queued:

Liu ShuoX (6):
      pstore: clarify clearing of _read_cnt in ramoops_context
      pstore: skip zero size persistent ram buffer in traverse
      pstore: Fix NULL pointer fault if get NULL prz in ramoops_get_next_prz
      pstore: Correct the max_dump_cnt clearing of ramoops
      pstore: Fix buffer overflow while write offset equal to buffer size
      pstore: Fix memory leak when decompress using big_oops_buf

Thanks

-Tony
