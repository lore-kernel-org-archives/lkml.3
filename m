Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3ANNpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:45:19 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:1935 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab3ANNpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:45:17 -0500
Subject: Re: checkpatch.pl "uninitialized value"
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Schrober <franzschrober@yahoo.de>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 Jan 2013 14:45:06 +0100
In-Reply-To: <8765116.NauFasYmb5@bentobox>
References: <8765116.NauFasYmb5@bentobox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1358171107.15075.89.camel@thorin>
Mime-Version: 1.0
X-DCC-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, 2013-01-14 at 14:42 +0100, Schrober wrote:
[...]
> it seems the current version of checkpatch.pl in linux-next ist broken. I get
> a lot of
> 
> Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3383.
> Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3386.
> Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3383.
> Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3386.
> Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3383.
> Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3386.

on which file?
If you would have added the command line to trivially reproduce that (or
whatever you did to get it), people are more likely to look into it.

MfG,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

