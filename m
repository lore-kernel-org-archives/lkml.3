Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3JHPOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:14:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45738 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab3JHPOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:14:18 -0400
Message-ID: <1381245279.20801.13.camel@buffalo>
Subject: Re: [tpmdd-devel] [PATCH] tpm: xen-tpmfront: fix missing
 declaration of xen_domain
From: Ashley D Lai <adlai@linux.vnet.ibm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        stefano.stabellini@eu.citrix.com,
        Rob Herring <rob.herring@calxeda.com>, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, Sirrix AG <tpmdd@sirrix.com>
Date: Tue, 08 Oct 2013 10:14:39 -0500
In-Reply-To: <1381182353-12449-1-git-send-email-robherring2@gmail.com>
References: <1381182353-12449-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100815-5806-0000-0000-000022FDF79D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 16:45 -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> xen-tpmfront fails to build on arm64 with the following error:
> 

Reviewed-by: Ashley Lai <adlai@linux.vnet.ibm.com>
Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>

Thanks,
--Ashley Lai

