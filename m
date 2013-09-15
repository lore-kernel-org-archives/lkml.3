Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab3IOQcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 12:32:52 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36023 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757100Ab3IOQcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 12:32:51 -0400
Date: Sun, 15 Sep 2013 17:32:49 +0100
From: Hedi Berriche <hedi@sgi.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Eric Biederman <ebiederm@xmission.com>, Jiri Kosina <trivial@kernel.org>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH TRIVIAL] kexec: Typo s/the/then/
Message-ID: <20130915163249.GG8742@dangermouse.emea.sgi.com>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Jiri Kosina <trivial@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <1379237737-3070-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1379237737-3070-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 10:36 Geert Uytterhoeven wrote:
| Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
| ---
|  kernel/kexec.c |    2 +-
|  1 file changed, 1 insertion(+), 1 deletion(-)
| 
| diff --git a/kernel/kexec.c b/kernel/kexec.c
| index 2a74f30..490afc0 100644
| --- a/kernel/kexec.c
| +++ b/kernel/kexec.c
| @@ -921,7 +921,7 @@ static int kimage_load_segment(struct kimage *image,
|   *   reinitialize them.
|   *
|   * - A machine specific part that includes the syscall number
| - *   and the copies the image to it's final destination.  And
| + *   and then copies the image to it's final destination.  And
|   *   jumps into the image at entry.

Well, if you're fixing typos, might as well get rid of the wrong "it's"
and turn into "its".

Cheers,
Hedi.
-- 
Be careful of reading health books, you might die of a misprint.
	-- Mark Twain
