Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244Ab3D3Qvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:51:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38843 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760830Ab3D3Qv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:51:28 -0400
Message-ID: <1367326618.2587.10.camel@joe-AO722>
Subject: Re: [TRIVIAL PATCH 08/26] m32r: Convert print_symbol to %pSR
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1304291521070.11889@pobox.suse.cz>
References: <cover.1355335227.git.joe@perches.com>
	 <df548c6911e1b46a73b9a417efb800d08e0ecf8f.1355335228.git.joe@perches.com>
	 <swfr4mu3b2o.wl%hirokazu.takata.wj@renesas.com>
	 <alpine.LNX.2.00.1304291521070.11889@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 30 Apr 2013 05:56:58 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 15:21 +0200, Jiri Kosina wrote:
> On Thu, 13 Dec 2012, Hirokazu Takata wrote:
> > Acked-by: Hirokazu Takata <takata@linux-m32r.org>

Hi Jiri.

It's really not useful to cherry-pick a few patches
from this series.

You must first apply patch 1 of 26 before applying any
of the others as a new vsprintf pointer extension %pSR
is added by that patch.



