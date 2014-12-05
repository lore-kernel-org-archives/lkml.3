Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaLEPXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:23:38 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaLEPXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:23:37 -0500
Message-ID: <5481CDF4.3060706@nod.at>
Date: Fri, 05 Dec 2014 16:23:32 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] UBI: Fastmap: Optimize anchor PEB search
References: <1417350157-9373-1-git-send-email-richard@nod.at> <1417350157-9373-5-git-send-email-richard@nod.at>
In-Reply-To: <1417350157-9373-5-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.11.2014 um 13:22 schrieb Richard Weinberger:
> The UBI RB trees are sorted by the PEB number, hence
> we don't have to traverse the whole tree because ubi_rb_for_each_entry()
> walks the tree in sort order.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Please ignore this patch. It is horrible wrong.

*facepalm*,
//richard
