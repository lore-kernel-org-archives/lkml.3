Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbaGTIE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 04:04:28 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36518 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaGTIEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 04:04:25 -0400
Date: Sun, 20 Jul 2014 10:04:20 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH v4 1/6] acerhdf: Adding support for "manual mode"
Message-ID: <20140720080420.GA28707@rhlx01.hs-esslingen.de>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1405817480-25347-1-git-send-email-peter@piie.net>
 <1405817480-25347-2-git-send-email-peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405817480-25347-2-git-send-email-peter@piie.net>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 20, 2014 at 02:51:15AM +0200, Peter Feuerer wrote:
> @@ -127,105 +138,107 @@ struct bios_settings_t {
>  	unsigned char fanreg;
>  	unsigned char tempreg;
>  	struct fancmd cmd;
> +	int mcmd_enable;
>  };
>  
> +
>  /* Register addresses and values for different BIOS versions */
>  static const struct bios_settings_t bios_tbl[] = {

Change-unrelated content here, might want to move away.

Suggestion (if ok from a commit revision/history POV):
git rebase -i s:/'acerhdf: Adding support for "manual mode"'~1
<"e"dit first commit>
git checkout -p s:/'acerhdf: Adding support for "manual mode"'
<grab hunk [split as needed]>
git commit -m "FIXUP"
git rebase --continue
git rebase -i s:/'acerhdf: Adding support for "manual mode"'~1
<move FIXUP line post [PATCH v4 6/6] acerhdf: minor clean up>
<do "f"ixup>


Sorry that I didn't find worse breakage during my review
than this si{mp|ng}le line ;)

Andreas
