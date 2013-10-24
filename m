Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3JXIoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:44:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40260 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab3JXIod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:44:33 -0400
Message-ID: <5268DDE0.4090602@zytor.com>
Date: Thu, 24 Oct 2013 09:44:16 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Landley <rob@landley.net>, Tao Ma <boyu.mt@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Documentation/ABI: Document the non-ABI status of Kconfig
 and symbols
References: <20131024084104.GA2861@leaf>
In-Reply-To: <20131024084104.GA2861@leaf>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 09:41 AM, Josh Triplett wrote:
> Discussion at Kernel Summit made it clear that the presence or absence
> of specific Kconfig symbols are not considered ABI, and that no
> userspace (or bootloader, etc) should rely on them.
> 
> In addition, kernel-internal symbols are well established as non-ABI,
> per Documentation/stable_api_nonsense.txt.
> 
> Document both of these in Documentation/ABI/README, in a new section for
> notable bits of non-ABI.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Good initiative.

Acked-by: H. Peter Anvin <hpa@zytor.com>

