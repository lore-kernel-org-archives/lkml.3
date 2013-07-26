Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877Ab3GZWaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:30:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:56673 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab3GZWaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:30:19 -0400
Message-ID: <1374877799.9200.29.camel@pasglop>
Subject: Re: [PATCH 2/2] drivers/crypto/nx: fix limits to sg lists for SHA-2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>,
        Joel Schopp <jschopp@linux.vnet.ibm.com>,
        Joy Latten <jmlatten@linux.vnet.ibm.com>
Date: Sat, 27 Jul 2013 08:29:59 +1000
In-Reply-To: <1374858488-24658-3-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1374858488-24658-1-git-send-email-mhcerri@linux.vnet.ibm.com>
	 <1374858488-24658-3-git-send-email-mhcerri@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-26 at 14:08 -0300, Marcelo Cerri wrote:
> 
> Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> Signed-off-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
> Signed-off-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
> Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
> ---

Why that enormous S-O-B list ? Did every of these people actually carry
the patch ? If it's just acks or reviews, please use the corresponding
Acked-by or Reviewed-by.

Cheers,
Ben.


