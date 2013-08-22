Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab3HVNiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:38:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40925 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753028Ab3HVNix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:38:53 -0400
Message-ID: <1377178732.12003.32.camel@joe-AO722>
Subject: Re: [PATCH] iommu: No need to pass '0x' when '%pa' is used
From: Joe Perches <joe@perches.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: joro@8bytes.org, festevam@gmail.com, linux-kernel@vger.kernel.org
Date: Thu, 22 Aug 2013 06:38:52 -0700
In-Reply-To: <1377177942-24965-1-git-send-email-fabio.estevam@freescale.com>
References: <1377177942-24965-1-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 10:25 -0300, Fabio Estevam wrote:
> Commit 6197ca82 (iommu: Use %pa and %zx instead of casting) introduced the 
> usage of '%pa', but still kept the '0x', which leads to printing '0x0x'.
> Remove the '0x' when '%pa' is used.

And there are no other uses of "0x%pa" in current or -next.

Thanks Fabio.


