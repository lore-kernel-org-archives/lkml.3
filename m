Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3DURNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 13:13:05 -0400
Received: from one.firstfloor.org ([193.170.194.197]:50249 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3DURNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 13:13:04 -0400
Date: Sun, 21 Apr 2013 19:13:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86: Fix AMD K6 indirect call check v2
Message-ID: <20130421171302.GX16732@two.firstfloor.org>
References: <1366562995-20530-1-git-send-email-andi@firstfloor.org>
 <51741CB2.3090209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51741CB2.3090209@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe it would be even better to just code the indirect call instruction
> in assembly?

I only have the simple low risk fix to offer. If you want something
gold plated you have to do/test it yourself.

-Andi

