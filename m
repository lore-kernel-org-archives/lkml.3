Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaGTUUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 16:20:53 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55044 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaGTUUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 16:20:52 -0400
Date: Sun, 20 Jul 2014 22:20:48 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 1/6] acerhdf: Adding support for "manual mode"
Message-ID: <20140720202048.GA14133@rhlx01.hs-esslingen.de>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1405817480-25347-1-git-send-email-peter@piie.net>
 <1405817480-25347-2-git-send-email-peter@piie.net>
 <20140720080420.GA28707@rhlx01.hs-esslingen.de>
 <cone.1405852973.378940.3229.1000@galar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1405852973.378940.3229.1000@galar>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 20, 2014 at 12:42:53PM +0200, Peter Feuerer wrote:
> Hi Andreas,
> 
> Andreas Mohr writes:
> >On Sun, Jul 20, 2014 at 02:51:15AM +0200, Peter Feuerer wrote:
> >>@@ -127,105 +138,107 @@ struct bios_settings_t {
> >> 	unsigned char fanreg;
> >> 	unsigned char tempreg;
> >> 	struct fancmd cmd;
> >>+	int mcmd_enable;
> >> };
> >>+
> >> /* Register addresses and values for different BIOS versions */
> >> static const struct bios_settings_t bios_tbl[] = {
> >
> >Change-unrelated content here, might want to move away.
> 
> You mean this newline?

Yup.

> >Suggestion (if ok from a commit revision/history POV):
> >git rebase -i s:/'acerhdf: Adding support for "manual mode"'~1
> ><"e"dit first commit>
> >git checkout -p s:/'acerhdf: Adding support for "manual mode"'
> ><grab hunk [split as needed]>
> >git commit -m "FIXUP"
> >git rebase --continue
> >git rebase -i s:/'acerhdf: Adding support for "manual mode"'~1
> ><move FIXUP line post [PATCH v4 6/6] acerhdf: minor clean up>
> ><do "f"ixup>
> 
> If I understand this correctly, you want me to move this new line
> to patch 6, correct?

Yup, to a suitable "other stuff" location, which patch 6 likely would be.

> >Sorry that I didn't find worse breakage during my review
> >than this si{mp|ng}le line ;)
> 
> No problem, as long as you give your Acked-by / Reviewed-by ;)

Hmm, I'm unsure whether my involvement is sufficient for a full Reviewed-by
(think full replacement of core driver mechanisms as in bang-bang governor,
etc.).

But yeah, at least I can say I did review things
and I did not see any obvious issues.

Thanks,

Andreas
