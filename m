Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3AZKCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:02:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60652 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab3AZKCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:02:17 -0500
Date: Sat, 26 Jan 2013 11:05:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] edac: test correct variable in ->store function
Message-ID: <20130126100505.GA16044@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Doug Thompson <dougthompson@xmission.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20130126074924.GB14365@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130126074924.GB14365@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 10:49:24AM +0300, Dan Carpenter wrote:
> We're testing for ->show but calling ->store().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Good catch, applied.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
