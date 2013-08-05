Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3HENWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:22:12 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:46909 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3HENWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:22:10 -0400
Date: Mon, 5 Aug 2013 15:21:57 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        kvm@vger.kernel.org, Sanjay Lal <sanjayl@kymasys.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 1/3] mips/kvm: Improve code formatting in
 arch/mips/kvm/kvm_locore.S
Message-ID: <20130805132157.GB3470@linux-mips.org>
References: <1375388555-4045-1-git-send-email-ddaney.cavm@gmail.com>
 <1375388555-4045-2-git-send-email-ddaney.cavm@gmail.com>
 <51FFA5CD.3010406@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FFA5CD.3010406@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 02:17:01PM +0100, James Hogan wrote:

> 
> On 01/08/13 21:22, David Daney wrote:
> > From: David Daney <david.daney@cavium.com>
> > 
> > No code changes, just reflowing some comments and consistently using
> > tabs and spaces.  Object code is verified to be unchanged.
> > 
> > Signed-off-by: David Daney <david.daney@cavium.com>
> > Acked-by: Ralf Baechle <ralf@linux-mips.org>
> 
> 
> > +   	 /* Put the saved pointer to vcpu (s1) back into the DDATA_LO Register */
> 
> git am detects a whitespace error here ("space before tab in indent").
> It's got spaces before and after the tab actually.
> 
> >      /* load the guest context from VCPU and return */
> 
> this comment could have it's indentation fixed too
> 
> Otherwise, for all 3 patches:
> 
> Reviewed-by: James Hogan <james.hogan@imgtec.com>

I'm happy with the patch series as well and will fix this issue when
applying the patch.

  Ralf
