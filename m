Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab3GLO2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:28:48 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:38146 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab3GLO2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:28:46 -0400
Date: Fri, 12 Jul 2013 16:28:44 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Ming Lei <tom.leiming@gmail.com>, Linda Walsh <lkml@tlinx.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
Message-ID: <20130712142844.GA359@x4>
References: <51D9EAF3.4050804@tlinx.org>
 <CACVXFVPRwakzB6vtqRqL49StHKdugCpxDyNvx3VzcDC7GggFMQ@mail.gmail.com>
 <20130712080428.GB359@x4>
 <20130712134115.GI24008@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712134115.GI24008@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.07.12 at 15:41 +0200, Borislav Petkov wrote:
> On Fri, Jul 12, 2013 at 10:04:28AM +0200, Markus Trippelsdorf wrote:
> > Mauro said he will fix this in the coming weeks:
> > 
> > http://article.gmane.org/gmane.linux.kernel/1522719
> 
> Here's a possible fix which works fine here. Markus, if you could verify
> please...

Yes, it's working fine here, too. Thanks Boris.

-- 
Markus
