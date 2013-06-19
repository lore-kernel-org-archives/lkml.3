Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301Ab3FSLJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:09:09 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:39253 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933991Ab3FSLJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:09:07 -0400
Date: Wed, 19 Jun 2013 13:08:12 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, juan.david.gonzalez.cobas@cern.ch,
        cota@braap.org, siglesias@igalia.com, gregkh@linuxfoundation.org,
        rob@landley.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] FMC: add needed headers
Message-ID: <20130619110812.GA26690@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <2530586.aQgWYlUvJa@wuerfel>
References: <2530586.aQgWYlUvJa@wuerfel>
  <cover.1371018406.git.rubini@gnudd.com>
 <1d3aedf8636f4bed4ffda25e13acd853bf8e08fb.1371018406.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The use of the 'readl' and 'writel' identifiers here causes build errors on
> architectures where those are macros. This renames the fields to read32/write32
> to avoid the problem.

Thanks.  I'll apply the same to my repo and related drivers.

Acked-by: Alessandro Rubini <rubini@gnudd.com>

/alessandro
