Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935597AbaH0RUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:20:51 -0400
Received: from p02c11o144.mxlogic.net ([208.65.144.77]:36721 "EHLO
	p02c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934674AbaH0RUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:20:49 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 13:20:48 EDT
X-MXL-Hash: 53fe13704c3447ae-bc3e75167fa4b2d4c04f23b7a076b9b3c775b698
X-MXL-Hash: 53fe114a57a744bd-00716036c4801f470e746f2c5b0ec14a326f0514
Date: Wed, 27 Aug 2014 13:11:35 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <linux-kernel@vger.kernel.org>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch: Add test for commit id formatting style in
 commit log
Message-ID: <20140827131135.6d789d26@jlaw-desktop.mno.stratus.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
In-Reply-To: 1404338448.14741.8.camel@joe-AO725
References: 1404338448.14741.8.camel@joe-AO725
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.1 cv=SuiE6Z+0 c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=fo-o9PDVgX8A:10 a=r4q]
X-AnalysisOut: [As0tedQoA:10 a=_KQqW7t0BisA:10 a=BLceEmwcHowA:10 a=kj9zAlc]
X-AnalysisOut: [Oel0A:10 a=uelBKuKpAAAA:8 a=YlVTAMxIAAAA:8 a=wKSZj8Sttjto6]
X-AnalysisOut: [QXgTh8A:9 a=CjuIK1q_8ugA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014082706); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Try to standardize on a 12 character long lower case
> commit id along with a description of parentheses and
> the quoted subject line
>
> ie: commit 0123456789ab ("commit description")

Hi Joe / Andrew,

I don't know if checkpatch is built for multiline regex, but I noticed
that this new check complained about the following commit message:

...
The PCI register read checking introduced in commit fe1b806f4f71
("qla2xxx: Disable adapter when we encounter a PCI disconnect") is
...

where 'commit hash ("message")' is split on multiple lines.

Dunno if that behavior is easily fixed, but thought I would report it.

Regards,

-- Joe
