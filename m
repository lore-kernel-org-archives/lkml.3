Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaK0RUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:20:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbaK0RUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:20:43 -0500
Date: Thu, 27 Nov 2014 18:20:37 +0100
From: Borislav Petkov <bp@suse.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: konrad.wilk@oracle.com, x86@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, david.vrabel@citrix.com,
        rshendershot@mchsi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
Message-ID: <20141127172037.GM4828@pd.tnic>
References: <5a9dde8d-1936-4910-a78a-15d4f9bfffc2@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5a9dde8d-1936-4910-a78a-15d4f9bfffc2@default>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 09:14:11AM -0800, Boris Ostrovsky wrote:
> The overnight tests passed. This includes baremetal, HVM and PV(H),
> 32- and 64-bit.

Cool. Want to send a proper patch for 3.18 and CC: stable?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
