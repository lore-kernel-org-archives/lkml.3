Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaETPHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:07:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34145 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaETPHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:07:30 -0400
Date: Tue, 20 May 2014 16:07:08 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: "Zhu, Lejun" <lejun.zhu@linux.intel.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, bin.yang@intel.com
Subject: Re: [PATCH 0/4] mfd: Intel SoC Power Management IC
Message-ID: <20140520160708.1382a6ab@alan.etchedpixels.co.uk>
In-Reply-To: <20140520145507.GU24991@lee--X1>
References: <1400079578-32329-1-git-send-email-lejun.zhu@linux.intel.com>
	<20140520145507.GU24991@lee--X1>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm missing the build files patch.  Can you ensure I was on the
> distribution list please?  Also, what's the reason for splitting the
> files out instead of having one single driver?

The same PMIC may be attached multiple ways, and multiple different PMIC
types may be attached.

So for example on the Baytrail/T platforms (ASUS T100 etc) you have
crystal cove via i2c, but a vendor could use a different PMIC - and there
will of course always be new PMIC devices coming along.

Equally on a Z2760 or similar (eg the Lenovo tablet 2) you may well have
the same PMIC attached to the system control unit. While there's nobody
afaik trying to sync the Android trees for Clovertrail+ with upstream at
this point I know there are external to Intel folks working on it for fun
and we need to allow for that.

Alan
