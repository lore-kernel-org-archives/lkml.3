Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaIAT7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 15:59:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56514 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbaIAT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 15:59:35 -0400
X-Sasl-enc: 44zPXc5ziEwH1TKamzc7rL6W9Mw+b1cjEYqFEuuWFy9j 1409601573
Date: Mon, 1 Sep 2014 16:59:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140901195921.GA18675@khazad-dum.debian.net>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <20140831194548.GA12628@khazad-dum.debian.net>
 <54037C07.8060703@zytor.com>
 <20140831201126.GB12628@khazad-dum.debian.net>
 <20140901051302.GA28402@nazgul.tnic>
 <5404A035.3070707@zytor.com>
 <20140901174322.GA15533@khazad-dum.debian.net>
 <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, H. Peter Anvin wrote:
> No, it is worse to rename it and have older kernels behave differently.
> Kernel options are basically super obscure to most people anyway.

Ok, so rename is out, although as long as the rename was accepted for
3.16-stable, it would be just 3.16 and 3.16.1 (and maybe 3.16.2) that would
not have the new name.

Options left are "keep it as is", or "add new and [optionally] deprecate
old".  I can't really tell for sure which one you'd prefer from your
previous answer.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
