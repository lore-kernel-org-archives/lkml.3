Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3G2PT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:19:28 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:52764 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab3G2PT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:19:26 -0400
Date: Mon, 29 Jul 2013 12:19:12 -0300
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>,
        Joel Schopp <jschopp@linux.vnet.ibm.com>,
        Joy Latten <jmlatten@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] drivers/crypto/nx: fix limits to sg lists for SHA-2
Message-ID: <20130729151912.GA4947@oc8526070481.ibm.com>
References: <1374858488-24658-1-git-send-email-mhcerri@linux.vnet.ibm.com>
 <1374858488-24658-3-git-send-email-mhcerri@linux.vnet.ibm.com>
 <1374877892.9200.30.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374877892.9200.30.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072915-2362-0000-0000-00000B540899
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We think that it's very likely that AES may also be affected by a
similar problem. But we still have to test it and I'd like to provide a
separated patch for it.

Regards,
Marcelo

On Sat, Jul 27, 2013 at 08:31:32AM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2013-07-26 at 14:08 -0300, Marcelo Cerri wrote:
> > ---
> >  drivers/crypto/nx/nx-sha256.c | 108 +++++++++++++++++++++++-----------------
> >  drivers/crypto/nx/nx-sha512.c | 113 ++++++++++++++++++++++++------------------
> >  2 files changed, 129 insertions(+), 92 deletions(-)
> 
> What about the other nx drivers ? They are not affected ?
> 
> Cheers,
> Ben.
> 
> 

