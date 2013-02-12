Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab3BLBYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 20:24:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:30497 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab3BLBYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 20:24:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,646,1355126400"; 
   d="scan'208";a="255680942"
Date: Mon, 11 Feb 2013 17:24:13 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH][WIP] dio rewrite
Message-ID: <20130212012413.GA30387@tassilo.jf.intel.com>
References: <20130212005326.GA6592@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212005326.GA6592@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 04:53:26PM -0800, Kent Overstreet wrote:
> I finally started hacking on the dio code, and it's far from done but
> it's turning out better than I expected so I thought I'd show off what
> I've got so far.

The critical metric for some of the highend workloads 
is the number of cache lines touched in the submission path
(especially potentially modified ones). How does your new code fare on that?

-Andi
