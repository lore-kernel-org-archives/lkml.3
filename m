Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaFBSln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:41:43 -0400
Received: from mout.web.de ([212.227.15.4]:50784 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaFBSlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:41:42 -0400
Date: Mon, 2 Jun 2014 20:42:15 +0200
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCHv3 net-next 0/4] bridge: multicast snooping patches / exports
Message-ID: <20140602184215.GA2460@Linus-Debian>
References: <1401732466-3027-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401732466-3027-1-git-send-email-linus.luessing@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V03:K0:tmNS9chopq1UVb4wZcLa0wO9A0OtHK1mWtmctNcIeHewQV8VCqn
 nEo95STnSLXW4+J8dAha2E8lQxsEODNpnmEBzcDlqWzu7/4rDcDAW+zFa26/dOAu+7ozlSO
 rkKBnH7Ulj/drFN76kF/fAe/5UzOhCYB6bcb2kThZTHTLOjlb5THnkbgJJeIEmjDXDpIbjQ
 dI6/O/mxVxYTswlIISP5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v3:

* use EXPORT_SYMBOL_GPL() instead of EXPORT_SYMBOL()

Cheers
