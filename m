Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaCLUSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:18:34 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43905 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaCLUSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:18:31 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [RFC PATCH v2 04/14] mtd: nand: define struct nand_timings
From: Warner Losh <imp@bsdimp.com>
In-Reply-To: <20140312190737.GA27388@obsidianresearch.com>
Date: Wed, 12 Mar 2014 14:18:27 -0600
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5B3F0425-9D7A-4D22-86A0-2E870E25396A@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com> <1391006064-28890-5-git-send-email-b.brezillon.dev@gmail.com> <531DC1A4.7010208@gmail.com> <20140311185554.GD31835@obsidianresearch.com> <53208F7D.8090104@gmail.com> <20140312190737.GA27388@obsidianresearch.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 12, 2014, at 1:07 PM, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

> On Wed, Mar 12, 2014 at 05:46:53PM +0100, Boris BREZILLON wrote:
>> I'm not a big fan of this name. I think timing structs should not
>> contain onfi in their names, because these timings are also
>> available on non ONFI chips.
> 
> Explicitly defering to the ONFI spec makes it clear what the
> definition of the timing parameter actually is.

This is good, since ONFI is a very public spec.

> If JEDEC has a different model then drivers will need to configure
> their interfaces a little differently.

JEDEC’s spec is just a public as ONFI’s, but in the past at least it has been difficult
to get without purchase.

> So we might end up with a jedec_sdr_timings too :|

And onfi_ddr_timings and jedec_ddr_timings since those timing modes are appearing
on shipping parts.

Warner

