Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500Ab3E1IZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:25:20 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:61933 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390Ab3E1IZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:25:18 -0400
Date: Tue, 28 May 2013 10:25:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: luto@amacapital.net, linux-kernel@vger.kernel.org, x86@kernel.org,
        trinity@vger.kernel.org
Subject: Re: [PATCH 0/5] x86: oops on uaccess faults outside of user addresses
Message-ID: <20130528082514.GA29730@gmail.com>
References: <cover.1369177867.git.luto@amacapital.net>
 <20130522.142847.791230763817666795.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522.142847.791230763817666795.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> Please don't mix networking and non-networking changes into a patch
> series.

As explained in 0/5 the networking fix justifies the first 4 patches. The 
networking fix is independent of the first 4 patches.

> Submit the networking patch to netdev@vger.kernel.org

He Cc:-ed the patch to netdev@vger.kernel.org. If you agree with it then 
the fix should probably be picked up ASAP.

Thanks,

	Ingo
