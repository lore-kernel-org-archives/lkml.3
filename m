Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaHZTzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:55:38 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:27321 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaHZTzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:55:37 -0400
Message-ID: <1409082317.28990.105.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/3] x86: Enable PAT to use cache mode translation tables
From: Toshi Kani <toshi.kani@hp.com>
To: Juergen Gross <jgross@suse.com>
Cc: stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, hpa@zytor.com, x86@kernel.org
Date: Tue, 26 Aug 2014 13:45:17 -0600
In-Reply-To: <1409033783-12136-3-git-send-email-jgross@suse.com>
References: <1409033783-12136-1-git-send-email-jgross@suse.com>
	 <1409033783-12136-3-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-26 at 08:16 +0200, Juergen Gross wrote:
> Update the translation tables from cache mode to pgprot values according to
> the PAT settings. This enables changing the cache attributes of a PAT index in
> just one place without having to change at the users side.
> 
> With this change it is possible to use the same kernel with different PAT
> configurations, e.g. supporting Xen.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

