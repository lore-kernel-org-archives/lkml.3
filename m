Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab3G2PYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:24:51 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:51718 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3G2PYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:24:48 -0400
Date: Mon, 29 Jul 2013 12:24:37 -0300
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>,
        Joel Schopp <jschopp@linux.vnet.ibm.com>,
        Joy Latten <jmlatten@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] drivers/crypto/nx: fix limits to sg lists for SHA-2
Message-ID: <20130729152437.GB4947@oc8526070481.ibm.com>
References: <1374858488-24658-1-git-send-email-mhcerri@linux.vnet.ibm.com>
 <1374858488-24658-3-git-send-email-mhcerri@linux.vnet.ibm.com>
 <1374877799.9200.29.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374877799.9200.29.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072915-9254-0000-0000-00000D300C74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Everyone in S-O-B list has participated to solve this bug with code
and/or ideas of how to fix it, as well as reviewing and testing the
final version of the patches.

I'd like to keep it as it is if you don't mind.

Regards.
Marcelo

On Sat, Jul 27, 2013 at 08:29:59AM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2013-07-26 at 14:08 -0300, Marcelo Cerri wrote:
> > 
> > Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> > Signed-off-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
> > Signed-off-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
> > Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
> > ---
> 
> Why that enormous S-O-B list ? Did every of these people actually carry
> the patch ? If it's just acks or reviews, please use the corresponding
> Acked-by or Reviewed-by.
> 
> Cheers,
> Ben.
> 
> 

