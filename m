Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaDTNQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 09:16:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54718 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321AbaDTNQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 09:16:39 -0400
Date: Sun, 20 Apr 2014 15:16:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Christian =?utf-8?B?S8O2bmln?= <deathsimple@vodafone.de>
Cc: Alex Deucher <alexdeucher@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: more radeon fun: uvd this time
Message-ID: <20140420131633.GF19667@pd.tnic>
References: <20140420122621.GE19667@pd.tnic>
 <5353C1EF.80407@vodafone.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5353C1EF.80407@vodafone.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 02:47:43PM +0200, Christian König wrote:
> Is this a regression? UVD is released for quite a while.

Well, that's a laptop which I seldomly boot - the previous installed
kernel is 3.13-rc2+.

> Make sure you have updated firmware installed as well.

Yep, that was it. Now the UVD gets initialized properly.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
