Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966475Ab3HIJbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:31:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965824Ab3HIJbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:31:18 -0400
Date: Fri, 9 Aug 2013 11:31:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Manoj Chourasia <mchourasia@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Wu <lekensteyn@gmail.com>
Subject: Re: [PATCH] hidraw: correctly deallocate memory on device
 disconnect
In-Reply-To: <F17EA9D408D3644C864D33B8F5E1CC526DAC2ACF47@BGMAIL02.nvidia.com>
Message-ID: <alpine.LNX.2.00.1308091130420.13089@pobox.suse.cz>
References: <F17EA9D408D3644C864D33B8F5E1CC526DAC2ACF47@BGMAIL02.nvidia.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Manoj Chourasia wrote:

> This is mail is in regard to your commit for hidaw devices. We were 
> seeing kernel crashes while connect and disconnect a hidraw device and 
> we were hitting rb tree corruption in vmalloc and kernel was crashing 
> because of null pointer de-reference. Later we figure out that was 
> because the hid device disconnect is freeing memory which later got 
> access by hidraw_read and hid_write.

Now applied, thanks Manoj, thanks Peter.

-- 
Jiri Kosina
SUSE Labs
