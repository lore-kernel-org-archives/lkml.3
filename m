Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab3KGFDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:03:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab3KGFDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:03:48 -0500
Date: Wed, 6 Nov 2013 22:01:09 +0100
From: Michal Marek <mmarek@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] scripts/kernel-doc: make unknown function prototype a
	Warning instead of an Error
Message-ID: <20131106210109.GA22142@pobox.suse.cz>
References: <52607371.3060805@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52607371.3060805@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 04:32:01PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> When scripts/kernel-doc cannot understand a function prototype,
> it had been generating a fatal error and stopping immediately.
> Make this a Warning instead of an Error and keep going.
> 
> Note that this can happen if the kernel-doc notation that is being
> parsed is not actually a function prototype; maybe it's a struct or
> something else, so I added "function" to the warning message to try
> to make it clearer that scripts/kernel-doc is looking for a function
> prototype here.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:	Mark Brown <broonie@kernel.org>

Applied to kbuild.git#misc, thanks.

Michal
