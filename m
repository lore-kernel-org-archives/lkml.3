Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab3CSPqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:46:37 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:44825 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757005Ab3CSPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:46:36 -0400
Date: Tue, 19 Mar 2013 15:45:58 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Do not select GENERIC_HARDIRQS_NO_DEPRECATED
Message-ID: <20130319154558.GD507@arm.com>
References: <1362516222.16460.121.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362516222.16460.121.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 08:43:42PM +0000, Paul Bolle wrote:
> Config option GENERIC_HARDIRQS_NO_DEPRECATED was removed in commit
> 78c89825649a9a5ed526c507603196f467d781a5 ("genirq: Remove the now obsolete
> config options and select statements"), but the select was accidentally
> reintroduced in commit 8c2c3df31e3b87cb5348e48776c366ebd1dc5a7a ("arm64:
> Build infrastructure").
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied, thanks (it will appear in mainline at some point).

-- 
Catalin
