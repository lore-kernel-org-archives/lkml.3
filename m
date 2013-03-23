Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab3CWNv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 09:51:59 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44430 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3CWNv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 09:51:58 -0400
Date: Sat, 23 Mar 2013 14:51:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 12/29] x86, tsx: Add a per thread transaction disable
 count
Message-ID: <20130323135156.GJ20853@two.firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
 <1364001923-10796-13-git-send-email-andi@firstfloor.org>
 <20130323115115.GA10821@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323115115.GA10821@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This surely can be a bitfield like the other two below. It is basically
> begging to be one.

Bit fields are slower and larger in code and unlike the others this is on hot
paths.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
