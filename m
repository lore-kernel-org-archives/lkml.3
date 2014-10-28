Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaJ1Ots (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:49:48 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:43778 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaJ1Otq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:49:46 -0400
Date: Tue, 28 Oct 2014 15:49:33 +0100
From: Johan Hedberg <johan.hedberg@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org
Subject: Re: linux-next: build failure after merge of the bluetooth tree
Message-ID: <20141028144933.GA22555@t440s>
References: <20141027131956.68b62e5e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027131956.68b62e5e@canb.auug.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Oct 27, 2014, Stephen Rothwell wrote:
> After merging the bluetooth tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> net/bluetooth/smp.o: In function `test_smp':
> smp.c:(.init.text+0x0): multiple definition of `init_module'
> net/bluetooth/af_bluetooth.o:af_bluetooth.c:(.init.text+0x0): first defined here
> 
> Probably caused by commit 4cd3362da899 ("Bluetooth: Add skeleton for
> SMP self-tests").
> 
> I have used the bluetooth tree from next-20141023 for today.

We've applied a revert patch for the SMP self-tests to the
bluetooth-next tree until we figure out how to fix this properly.

Johan
