Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaJUJyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:54:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:58553 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280AbaJUJyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:54:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,761,1406617200"; 
   d="scan'208";a="617768445"
Message-ID: <1413885267.7906.426.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/2] jffs2: fix buffer dump debug output
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Cc: Joe Perches <joe@perches.com>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com
Date: Tue, 21 Oct 2014 12:54:27 +0300
In-Reply-To: <54462BB6.5020405@atmel.com>
References: <cover.1413878259.git.cyrille.pitchen@atmel.com>
		 <21ad981db8c65d3f00be3d9a254cae78cf40b96d.1413878259.git.cyrille.pitchen@atmel.com>
	 <1413879465.12828.1.camel@perches.com> <54462BB6.5020405@atmel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 11:47 +0200, Cyrille Pitchen wrote:
> thanks for your comment. Indeed using print_hex_dump() would be a good idea
> since it would avoid each driver to implement its own version of buffer dumps.
> Reading the source code of print_hex_dump(), the output format would change a
> little bit:
> the output would no longer be aligned to JFFS2_BUFDUMP_BYTES_PER_LINE boundary
> using leading spaces.
> If it's ok to change the output format it's good for me as well.

Changing format is OK, this is just a debugging cruft. But it is OK only
if you test the changes. If you are unable to test the changes, it is
better to avoid doing non-trivial changes.

