Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161463AbaDPOWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:22:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35851 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161180AbaDPOWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:22:37 -0400
Date: Wed, 16 Apr 2014 16:22:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthias Graf <matthias.graf@st.ovgu.de>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
Message-ID: <20140416142232.GF16741@pd.tnic>
References: <532C727F.1080803@st.ovgu.de>
 <20140321172742.GA2846@pd.tnic>
 <532C97DF.9010201@st.ovgu.de>
 <20140321201352.GC1338@pd.tnic>
 <533069E4.10002@st.ovgu.de>
 <533C1B47.8080709@st.ovgu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <533C1B47.8080709@st.ovgu.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 04:14:31PM +0200, Matthias Graf wrote:
> I now tried booting with a different graphics card (on the same
> machine), and it resolved the problem. Therefore, it definitely has
> something to do with graphics.
> 
> It is a Sapphire ATI Radeon HD 4830 (RV770 chip).

As Tony said, you might want to try a stock 3.14 kernel with the old GPU
which causes the MCEs and see whether if it still triggers. If you still
want to hunt this down, that is.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
