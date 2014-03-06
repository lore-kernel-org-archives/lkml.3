Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaCFWHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:07:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38925 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaCFWG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:06:59 -0500
Date: Thu, 6 Mar 2014 17:06:45 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Lasse Collin <lasse.collin@tukaani.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kyle McMartin <kyle@infradead.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xz: Enable all filters by default in Kconfig
Message-ID: <20140306220645.GF14970@merlin.infradead.org>
References: <20140305193057.4a481aaf@tukaani.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305193057.4a481aaf@tukaani.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 07:30:57PM +0200, Lasse Collin wrote:
> From: Lasse Collin <lasse.collin@tukaani.org>
> 
> This restores the old behavior that existed before 2013-02-22.
> Disabling the filters only makes sense on embedded systems.
> 
> Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>

I'm happy with that compromise.
