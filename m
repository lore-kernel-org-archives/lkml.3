Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbaGRQRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:17:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60429 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762012AbaGRQRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:17:48 -0400
Date: Fri, 18 Jul 2014 18:17:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH v3 2/6] acerhdf: Adding support for new models
Message-ID: <20140718161740.GA29366@pd.tnic>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1399139966-10625-1-git-send-email-peter@piie.net>
 <1399139966-10625-3-git-send-email-peter@piie.net>
 <20140717094648.GB23869@pd.tnic>
 <cone.1405699613.361414.1043.1000@galar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1405699613.361414.1043.1000@galar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 06:06:53PM +0200, Peter Feuerer wrote:
> Everytime I send out a modified version of acerhdf.c to someone in the
> internet for trying out some changes, I increment the second minor
> version number. And from time to time I push things to Mainline, then
> I need to catch up with the numbering ;)

Right, that's a good way to know which version people are testing when
you're staring at dmesg.

> The major 0 is just from the ages, when all cool projects used to have a 0
> in front.
> 
> Maybe it would be a good idea to go for 1.0 when I implemented a better
> handling for the huge bios table.

Probably. You could at least increment it to 0.6 when you switch to the
bang-bang governor :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
