Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaJGLeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:34:05 -0400
Received: from ozlabs.org ([103.22.144.67]:50308 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaJGLeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:34:02 -0400
Message-ID: <1412681640.4133.0.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH v3 01/16] powerpc/cell: Move spu_handle_mm_fault() out
 of cell platform
From: Michael Neuling <mikey@neuling.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        imunsie@au.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Date: Tue, 07 Oct 2014 22:34:00 +1100
In-Reply-To: <20141007220855.75b64a57@canb.auug.org.au>
References: <1412678902-18672-1-git-send-email-mikey@neuling.org>
	 <1412678902-18672-2-git-send-email-mikey@neuling.org>
	 <20141007220855.75b64a57@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid);
> 
> This function is otherwise not included in this patch, so it should
> probably be removed (as the next patch removes it anyway).

Yeah, looks like I screwed it up slightly in the packing of these
patches.

Thanks.
Mikey

