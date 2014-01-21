Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaAUU4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:56:11 -0500
Received: from vps1.hno.se ([31.192.227.87]:35679 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaAUU4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:56:08 -0500
Message-ID: <1390337734.5046.24.camel@localhost>
Subject: Re: [linux-sunxi] Re: [RFC PATCH 0/9] mtd: nand: add sunxi NAND
 Flash Controller support
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: linux-sunxi@googlegroups.com
Cc: dev@linux-sunxi.org, Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jan 2014 21:55:34 +0100
In-Reply-To: <1390328011.5046.16.camel@localhost>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
	 <52D1494E.9090303@overkiz.com> <1389449230.19197.2.camel@localhost>
	 <52D1541F.4040400@overkiz.com> <1389456075.20989.11.camel@localhost>
	 <1389474709.22660.4.camel@localhost> <52D3ABB6.9030204@overkiz.com>
	 <1389606496.29053.16.camel@localhost>
	 <6de6ead1-e437-410b-91c0-74afb37dbf39@googlegroups.com>
	 <1390328011.5046.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tis 2014-01-21 klockan 19:13 +0100 skrev Henrik Nordström:
> > Are you sure ?
> > This thread says that only the first 1024 bytes of data (+ 96 bytes of
> > ECC) of each page are used:
> 
> yes I am sure. There was no page access commands between the sectors,
> only linear read of data,ecc,data,ecc.

Hmm.. but thinking back I am no longer so sure. Need to test this again
while verifying with logic probe what is going on.

Regards
Henrik

