Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaBSPg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:36:29 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:33782 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaBSPg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:36:28 -0500
Date: Wed, 19 Feb 2014 10:36:24 -0500
From: Tejun Heo <tj@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.torgue@st.com, linux-ide@vger.kernel.org,
        hdegoede@redhat.com
Subject: Re: [PATCH 3/3] ahci: st: Add support for ST's SATA IP
Message-ID: <20140219153624.GI10134@htj.dyndns.org>
References: <1392641818-23419-1-git-send-email-lee.jones@linaro.org>
 <1392641818-23419-3-git-send-email-lee.jones@linaro.org>
 <20140218233645.GP31892@mtj.dyndns.org>
 <20140219083025.GB10504@lee--X1>
 <20140219140458.GA10134@htj.dyndns.org>
 <20140219150121.GG10504@lee--X1>
 <20140219150654.GH10134@htj.dyndns.org>
 <20140219152336.GH10504@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219152336.GH10504@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 03:23:36PM +0000, Lee Jones wrote:
> Since when has maintaining core code been the responsibility of the
> leaf driver developers? If you're aware that the core code is
> sub-standard then it's you who should be fixing it.

No, there isn't this clear divide between core and the leaf
developers.  People working on the "core" don't just grow off the
ground.  You can't just go around piling mess around claiming that
it's not your responsbility and then expect someone else to clean up
after you.  How can that be *possibly* sustainable?

> I think it's great that forward thinking developers like Hans take on
> challenges to improve subsystems which are lacking in one way or

Yeah, which happened only because I pushed back and Hans isn't even
paid to do it.  Doesn't that say something?  Nobody is actually
helping Hans' work.  Not at all, nada, zilch.  Just complain when
directed towards it.

> another, but holding back other development while this process is
> ongoing is fundamentally wrong. Especially in this case where you're
> still actively reviewing/NACKing the core changes.
> 
> Changes to APIs should either support backward-capability or change all
> effected drivers. I haven't been able to apply the patches yet, so I
> can't tell which one of these holds true, but I believe it's the
> former. In which case any new driver using the _current_ (not old)
> API should fold neatly in. I've even offered to convert to the new API
> once it's Mainlined. How can I say fairer than that?
> 
> Finally, do try and stay at least a little bit professional on the
> MLs. That sort of disrespectful, rude behaviour may be how you guys do
> it at Redhat, but most will think it's nothing more than childish.

If you want me to be respectful towards you, don't be a crybaby
screaming "it's not fair".  It apparently isn't clear to you that you
have to chip in for the whole thing to be maintainable in the long
term.  Unfair... lol, that was a good one, really.

-- 
tejun
