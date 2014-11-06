Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaKFVzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:55:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44542 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaKFVzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:55:14 -0500
Date: Thu, 6 Nov 2014 16:55:11 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Aristeu Rozanski <arozansk@redhat.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] lib/halfmd4: make build optional
Message-ID: <20141106215511.GC3667@merlin.infradead.org>
References: <1415309253-13019-1-git-send-email-aris@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415309253-13019-1-git-send-email-aris@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 04:27:33PM -0500, Aristeu Rozanski wrote:
> +config HALF_MD4
> +	bool "Half MD4 transform"
> +	default y
> +	help
> +	  This option enables a reduced (32 bit output) version of MD4
> +	  transform.
> +

i'd suggest just def_bool n, and not have this prompt the user at all...
it only provides a single export_symbol, so a user doesn't really need
to care.

regards, Kyle
