Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaF2TM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 15:12:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52735 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaF2TM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 15:12:58 -0400
Date: Sun, 29 Jun 2014 21:12:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jeshwanth Kumar N K <jeshkumar555@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] User process tainting in linux-next tree
Message-ID: <20140629191254.GA13271@pd.tnic>
References: <CAC-LjFtjS5RS9=Lvb090-0aEnSdR1a28Scve2gvTR3yAZtt+9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC-LjFtjS5RS9=Lvb090-0aEnSdR1a28Scve2gvTR3yAZtt+9g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 11:48:02PM +0530, Jeshwanth Kumar N K wrote:
> Hello,
> 
>  I have created a bug in bugzilla
> https://bugzilla.kernel.org/show_bug.cgi?id=79171 , The native built
> Linux-next kernel is giving tainted Error. Can you please give me a
> pointer to solve this?

All those dmesg log files you've uploaded are incomplete and truncated
from the beginning and we want to see them from the beginning because
there is the first warning which is almost always the most important
one.

For that, boot your kernel with "log_buf_len=10M ignore_loglevel" and
then collect full dmesg by doing

dmesg > dmesg.log

which you can then upload to the bugzilla again.

Also, please try a newer linux-next tree or Linus' tree.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
