Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3IJWCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:02:06 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45592 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199Ab3IJWCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:02:04 -0400
Message-ID: <1378850521.23501.47.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 1/4] hpsa: add HP Smart Array Gen9 PCI ID's
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>
Date: Tue, 10 Sep 2013 15:02:01 -0700
In-Reply-To: <20130904200555.GA28147@beardog.cce.hp.com>
References: <20130904200555.GA28147@beardog.cce.hp.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-04 at 15:05 -0500, Mike Miller wrote:
> Patch 1 of 4
> 
> From: Mike Miller <mike.miller@hp.com>

Just for future reference, doing it this way means I have to edit the
patch.  The way git am works when applying patches is that if the first
body line is a keyword it recognises (like From: or Subject: or Date:)
it will fold that into the commit metadata, otherwise everything becomes
the commit message.  So by putting the redundant "patch 1 of 4" first,
git thinks the entire body is the commit message.

James

> This patch adds the PCI ID's for HP Smart Array Gen9 controllers. Please
> consider this patch for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> ---


