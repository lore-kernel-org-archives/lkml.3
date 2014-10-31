Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbaJaUKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:10:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56358 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756003AbaJaUKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:10:50 -0400
X-Sasl-enc: KLWr7ZQToKRCVylze3Xo9/e1CEOnF1VNY8mCqzZxBX7j 1414786249
Date: Fri, 31 Oct 2014 18:10:36 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 4/8] x86, microcode, intel: add error logging to early
 update driver
Message-ID: <20141031201036.GD27028@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-5-git-send-email-hmh@hmh.eng.br>
 <20141020150801.GE3524@pd.tnic>
 <20141021141015.GD22528@khazad-dum.debian.net>
 <20141030174134.GE11178@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030174134.GE11178@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Borislav Petkov wrote:
> On Tue, Oct 21, 2014 at 12:10:15PM -0200, Henrique de Moraes Holschuh wrote:
> > In fact, I have a patch somewhere that needs to add a new failure message:
> > we have several failure cases which we want to differentiate, at the very
> > least "processor didn't like it" and "it looks corrupt, so we didn't even
> > try to install it".
> 
> Actually, I don't want to be too chatty with the loader: if the
> microcode blob passes checks but it is not for the current processor
> we're running, not saying anything is what I want to do.
> 
> Why? Because I don't want to disturb people unnecessarily - if the
> microcode doesn't apply and everything else checks out, you simply don't
> need it.
> 
> If one really wants to know, one can always check /proc/cpuinfo and read
> out the microcode revision from the blob. But that is for the 1% of the
> curious ones - everyone else should simply install microcode blob and
> boot machine. Fire and forget.
> 
> Only the abnormal error cases should be vocal in saying what's wrong so
> that we can actually address those.

I've answered these points in one of the replies I just sent.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
