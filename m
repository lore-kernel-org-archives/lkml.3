Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab3DXIbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:31:46 -0400
Received: from ozlabs.org ([203.10.76.45]:50075 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab3DXIbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:31:45 -0400
Date: Wed, 24 Apr 2013 18:31:43 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, gang.chen@asianux.com, sfr@canb.auug.org.au,
        mikey@neuling.org, matt@ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: "attempt to move .org backwards" still show up
Message-ID: <20130424083142.GB26834@concordia>
References: <5177965D.9090406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5177965D.9090406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 04:22:53PM +0800, Mike Qiu wrote:
> Hi all
> 
> I get an error message when I compile the source code in Power7 platform
> use the newest upstream kernel.

Hi Mike,

It depends on what your .config is. What defconfig are you building?

cheers
