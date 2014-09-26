Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaIZEfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:35:45 -0400
Received: from ozlabs.org ([103.22.144.67]:54424 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbaIZEfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:35:44 -0400
Date: Fri, 26 Sep 2014 14:35:42 +1000
From: Anton Blanchard <anton@samba.org>
To: Michael Neuling <mikey@neuling.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH 09/15] powerpc/opal: Add PHB to cxl mode call
Message-ID: <20140926143542.445a7f9b@kryten>
In-Reply-To: <1411028820-29933-10-git-send-email-mikey@neuling.org>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	<1411028820-29933-10-git-send-email-mikey@neuling.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> This adds the OPAL call to change a PHB into cxl mode.
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>

Reviewed-by: Anton Blanchard <anton@samba.org>
