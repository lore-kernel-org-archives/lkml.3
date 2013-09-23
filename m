Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3IWNAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:00:47 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:65299 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3IWNAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:00:45 -0400
Date: Mon, 23 Sep 2013 09:00:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_isapnp: Don't use invalid I/O ports
Message-ID: <20130923130042.GG30946@htj.dyndns.org>
References: <1379019689-21467-1-git-send-email-linux@rainbow-software.org>
 <20130922214250.GA27616@mtj.dyndns.org>
 <52403944.7080401@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52403944.7080401@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 04:51:16PM +0400, Sergei Shtylyov wrote:
> >Applied to libata/for-3.13.
> 
>    Why only 3.13? Isn't it a simple fix?

Hmmm, maybe, the driver is such low impact, I don't think it matters
either way; otherwise, it should be marked -stable too.  It's a driver
which shouldn't be enabled by default by distros and I didn't think
it'd be worthwhile to create any traffic for it.  That said, if
there's a reason this matters, I'd be happy to add -stable and push it
through ASAP.

Thanks.

-- 
tejun
