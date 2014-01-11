Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaAKFt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 00:49:58 -0500
Received: from mail-ie0-f194.google.com ([209.85.223.194]:39622 "EHLO
	mail-ie0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaAKFt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 00:49:56 -0500
MIME-Version: 1.0
In-Reply-To: <1389413226.84382.YahooMailNeo@web164002.mail.gq1.yahoo.com>
References: <1389413226.84382.YahooMailNeo@web164002.mail.gq1.yahoo.com>
Date: Fri, 10 Jan 2014 23:49:56 -0600
Message-ID: <CA+jnaaWci3a5u0N6un4sGDDafTpJG6dxQ_JBxyb9SgJSpfehEQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Staging: comedi: Checkpatch cleanups in ni_mio_common.c
From: Chase Southwood <chase.southwood@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, left out some of my cover letter.  Here is the amended patchset
cover letter.

On Fri, Jan 10, 2014 at 10:07 PM, Chase Southwood
<chase.southwood@yahoo.com> wrote:
>
> This patch series fixes several warnings reported by checkpatch.pl in ni_mio_common.c of the comedi driver.
>
> Among the issues fixed:
> *Many unnecessary braces have been removed.
> *Improper indentation has been corrected.
> *Extra whitespace before semicolons has been removed.
> *Extra whitespace after function pointer name has been removed.
>
> Several checkpatch warnings still remain (mainly 80 character+ line lengths), but no new warnings have been introduced, and no functionality changes have been made.
>

Chase Southwood (3):
Staging: comedi: fix numerous brace coding style issues in ni_mio_common.c.
Staging: comedi: fix indentation coding style issue in ni_mio_common.c.
Staging: comedi: fix extra whitespace style issues in ni_mio_common.c.

drivers/staging/comedi/drivers/ni_mio_common.c | 138 +++++++++----------------
1 file changed, 50 insertions(+), 88 deletions(-)
