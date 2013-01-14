Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3ANNuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:50:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57535 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755513Ab3ANNuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:50:05 -0500
Message-ID: <1358171412.19400.10.camel@joe-AO722>
Subject: Re: checkpatch.pl "uninitialized value"
From: Joe Perches <joe@perches.com>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Schrober <franzschrober@yahoo.de>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 Jan 2013 05:50:12 -0800
In-Reply-To: <1358171107.15075.89.camel@thorin>
References: <8765116.NauFasYmb5@bentobox> <1358171107.15075.89.camel@thorin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 14:45 +0100, Bernd Petrovitsch wrote:
> On Mon, 2013-01-14 at 14:42 +0100, Schrober wrote:
> [...]
> > it seems the current version of checkpatch.pl in linux-next ist broken. I get
> > a lot of
> > 
> > Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3383.

> on which file?

Any file with a usleep_range or a memset

> If you would have added the command line to trivially reproduce that (or
> whatever you did to get it), people are more likely to look into it.

Try this patch:
https://lkml.org/lkml/2013/1/10/444



