Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaGDU7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:59:49 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55480 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaGDU7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:59:47 -0400
Date: Fri, 4 Jul 2014 22:59:41 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: Pawel Lebioda <pawel.lebioda89@gmail.com>
Cc: Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julian Andres Klode <jak@jak-linux.org>, ac100@lists.launchpad.net,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nvec: remove unneccessary 'else' after 'return'
 statement
Message-ID: <20140704205941.GA7406@jak-x230>
Mail-Followup-To: Pawel Lebioda <pawel.lebioda89@gmail.com>,
	Marc Dietrich <marvin24@gmx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Andres Klode <jak@jak-linux.org>, ac100@lists.launchpad.net,
	linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20140704195746.GA4346@ThinkPad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704195746.GA4346@ThinkPad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 09:57:50PM +0200, Pawel Lebioda wrote:
> Hi,
>
> This patch fixes the following warning reported by checkpatch.pl:
> 
> WARNING: else is not generally useful after a break or return
> #235: FILE: drivers/staging/nvec/nvec.c:235:
> 
> Regards
> Pawel Lebioda
> 
> Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
>  drivers/staging/nvec/nvec.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Hi Pawel,

Please format your patches correctly. There should be no
"Hi", no "Regards", etc. After the signed off should be a
dashed line.

Use git format-patch to format patches and you can send
them using git-send-email.

See Documentation/SubmittingPatches for more details

Thanks,
-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

Be friendly, do not top-post, and follow RFC 1855 "Netiquette".
    - If you don't I might ignore you.
