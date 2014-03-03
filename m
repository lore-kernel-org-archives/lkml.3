Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaCCAin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:38:43 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:40428 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaCCAim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:38:42 -0500
X-Greylist: delayed 998 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2014 19:38:42 EST
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH 1/1] Documentation/filesystems/ntfs.txt: Remove changelog reference
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <20140227194314.bfd78fd074c1b45de1912923@skynet.be>
Date: Mon, 3 Mar 2014 00:21:58 +0000
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4A739357-078C-4E90-8C94-87C190394E39@tuxera.com>
References: <20140227194314.bfd78fd074c1b45de1912923@skynet.be>
To: Fabian Frederick <fabf@skynet.be>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, thanks.

Andrew, if you haven't already, can you please take that one for integration via your mm series?  Thanks!

Best regards,

	Anton

On 27 Feb 2014, at 11:43, Fabian Frederick <fabf@skynet.be> wrote:

> File was removed in the following commit :
> 7c821a179f91c3ad52588400ce52a7fb48b9868c ("Remove fs/ntfs/ChangeLog")
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> Documentation/filesystems/ntfs.txt | 2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/ntfs.txt b/Documentation/filesystems/ntfs.txt
> index 791af8d..61947fa 100644
> --- a/Documentation/filesystems/ntfs.txt
> +++ b/Documentation/filesystems/ntfs.txt
> @@ -455,8 +455,6 @@ not have this problem with odd numbers of sectors.
> ChangeLog
> =========
> 
> -Note, a technical ChangeLog aimed at kernel hackers is in fs/ntfs/ChangeLog.
> -
> 2.1.30:
> 	- Fix writev() (it kept writing the first segment over and over again
> 	  instead of moving onto subsequent segments).
> -- 
> 1.8.1.4

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge
J.J. Thomson Avenue, Cambridge, CB3 0RB, UK

