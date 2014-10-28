Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaJ1Eh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:37:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJ1EhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:37:22 -0400
Date: Mon, 27 Oct 2014 21:37:19 -0700
From: Darren Hart <dvhart@infradead.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: platform-driver-x86@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quirk for Lenovo Yoga 3: no rfkill switch
Message-ID: <20141028043719.GC60814@vmdeb7>
References: <11408587.sP876r0cR3@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11408587.sP876r0cR3@tachyon.chronox.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 04:09:50AM +0100, Stephan Mueller wrote:
> The Yoga 3 does not contain any physical rfkill switch. Therefore
> disable the rfkill switch identically to the Yoga 2 approach. 
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Queued, thanks Stephan.

-- 
Darren Hart
Intel Open Source Technology Center
