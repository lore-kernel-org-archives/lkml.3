Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaJBXsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 19:48:37 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:59782 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaJBXsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 19:48:35 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] NTFS: Remove bogus space.
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <Pine.LNX.4.64.1410030041150.31680@hermes-1.csi.cam.ac.uk>
Date: Fri, 3 Oct 2014 00:48:32 +0100
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-NTFS-Dev@lists.sourceforge.net,
        Andrea Gelmini <andrea.gelmini@gelma.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <E58C460F-DBA5-40EA-90E1-BBCE9FF24200@cam.ac.uk>
References: <Pine.LNX.4.64.1410030041150.31680@hermes-1.csi.cam.ac.uk>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Forgot to say that this patch is from Andrea Gilmini originally (I had to re-do it as it is an old patch and the line numbers had changed)...

Best regards,

	Anton

On 3 Oct 2014, at 00:44, Anton Altaparmakov <aia21@cam.ac.uk> wrote:

> fs/ntfs/debug.c:124: WARNING: space prohibited between function name and 
> open parenthesis '('
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> Signed-off-by: Anton Altaparmakov <anton@tuxera.com>
> ---
> Hi Andrew,
> 
> Can you please take this simple patch and push it to Linus at some point?
> 
> Thanks a lot in advance!
> 
> Best regards,
> 
> 	Anton
> -- 
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
> Linux NTFS maintainer, http://www.linux-ntfs.org/
> 
> diff --git a/fs/ntfs/debug.c b/fs/ntfs/debug.c
> index dd6103c..825a54e 100644
> --- a/fs/ntfs/debug.c
> +++ b/fs/ntfs/debug.c
> @@ -112,7 +112,7 @@ void __ntfs_error(const char *function, const struct super_block *sb,
> /* If 1, output debug messages, and if 0, don't. */
> int debug_msgs = 0;
> 
> -void __ntfs_debug (const char *file, int line, const char *function,
> +void __ntfs_debug(const char *file, int line, const char *function,
> 		const char *fmt, ...)
> {
> 	struct va_format vaf;
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

