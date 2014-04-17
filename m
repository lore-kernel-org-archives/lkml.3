Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaDQNCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:02:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40602 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbaDQNCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:02:09 -0400
Date: Thu, 17 Apr 2014 15:02:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthias Graf <matthias.graf@st.ovgu.de>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
Message-ID: <20140417130207.GB4321@pd.tnic>
References: <532C727F.1080803@st.ovgu.de>
 <20140321172742.GA2846@pd.tnic>
 <532C97DF.9010201@st.ovgu.de>
 <20140321201352.GC1338@pd.tnic>
 <533069E4.10002@st.ovgu.de>
 <533C1B47.8080709@st.ovgu.de>
 <20140416142232.GF16741@pd.tnic>
 <534F73F6.7050804@st.ovgu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <534F73F6.7050804@st.ovgu.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 08:25:58AM +0200, Matthias Graf wrote:
> Ok. I tried:
> 
> 3.15-rc1 (16. April)
> failed.
> 
> Bisecting turned out:
> last working: 3.12.17
> first failing: 3.13

Ok, next steps would then be:

* test stock 3.12.
 -> if it works, bisect between 3.12 and 3.13.
 -> if not, bisect between 3.12 and 3.12.17

If all works out correctly, the bisection result will give us the patch
which broke things on your machine and which is still unfixed upstream.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
