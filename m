Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaATWiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:38:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41514 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaATWiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:38:08 -0500
Date: Mon, 20 Jan 2014 23:37:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Exner <dex@dragonslave.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Poor network performance x86_64.. also with 3.13
Message-ID: <20140120223752.GA3057@pd.tnic>
References: <52DAD66F.7080306@dragonslave.de>
 <20140118195026.GA15543@pd.tnic>
 <52DB0439.2060905@dragonslave.de>
 <52DDA2CD.9040001@dragonslave.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52DDA2CD.9040001@dragonslave.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 11:27:25PM +0100, Daniel Exner wrote:
> I just did the same procedure with Kernel Version 3.13: same poor rates.
> 
> I think I will try to see of 3.12.6 was still ok and bisect from there.

Or try something more coarse-grained like 3.11 first, then 3.12 and then
the -rcs in between.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
