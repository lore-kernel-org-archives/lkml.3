Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaIZLTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:19:46 -0400
Received: from ozlabs.org ([103.22.144.67]:33262 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbaIZLTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:19:44 -0400
Message-ID: <1411730383.1733.39.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH 02/15] powerpc/cell: Move data segment faulting code out
 of cell platform
From: Michael Neuling <mikey@neuling.org>
To: Anton Blanchard <anton@samba.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Date: Fri, 26 Sep 2014 21:19:43 +1000
In-Reply-To: <20140926140506.3d8fdac3@kryten>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	 <1411028820-29933-3-git-send-email-mikey@neuling.org>
	 <20140926140506.3d8fdac3@kryten>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 14:05 +1000, Anton Blanchard wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > __spu_trap_data_seg() currently contains code to determine the VSID
> > and ESID required for a particular EA and mm struct.
> > 
> > This code is generically useful for other co-processors.  This moves
> > the code of the cell platform so it can be used by other powerpc code.
> 
> Could we also mention:
> 
> and adds 1TB segment support.

Good point.  I'll add.


> > Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> 
> Reviewed-by: Anton Blanchard <anton@samba.org>

Thanks,
Mikey
