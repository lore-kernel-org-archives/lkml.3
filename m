Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423605Ab3FURlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:41:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53713 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423307Ab3FURlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:41:08 -0400
Date: Fri, 21 Jun 2013 19:40:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
Message-ID: <20130621174057.GI22006@pd.tnic>
References: <20130620073943.GE32694@pd.tnic>
 <51C3531D.3000600@linux.vnet.ibm.com>
 <20130620192928.GD19877@pd.tnic>
 <51C36288.4050405@linux.vnet.ibm.com>
 <20130620205726.GA20863@pd.tnic>
 <51C37291.40303@linux.vnet.ibm.com>
 <20130621073419.GC22006@pd.tnic>
 <51C404EA.10906@linux.vnet.ibm.com>
 <20130621083608.GE22006@pd.tnic>
 <CA+8MBbJkaiFhtmidBck6oiNXbzS=cUn-m2YkwWmNG+DjmtDiDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbJkaiFhtmidBck6oiNXbzS=cUn-m2YkwWmNG+DjmtDiDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 09:47:31AM -0700, Tony Luck wrote:
> On Fri, Jun 21, 2013 at 1:36 AM, Borislav Petkov <bp@alien8.de> wrote:
> > So ok, I'm persuaded, yet another bitfield it is ... :-\
> 
> Let's add some more comments on what each of these bitfields mean. Otherwise
> we will be going back over this next time we have a patch that touches one
> of them and we've all forgotten the subtle details explained in this
> e-mail thread.

Very good point - it's like you're reading my mind! I thought about
suggesting exactly that but then it slipped my mind with all the details
and commotion here.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
