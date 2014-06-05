Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaFEOFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:05:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaFEOFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:05:45 -0400
Date: Thu, 5 Jun 2014 10:05:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 03/13] kexec: Move segment verification code in a
 separate function
Message-ID: <20140605140506.GC17389@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-4-git-send-email-vgoyal@redhat.com>
 <20140604093254.GB4105@pd.tnic>
 <20140604184743.GC4406@redhat.com>
 <20140604203041.GF4105@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604203041.GF4105@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:30:41PM +0200, Borislav Petkov wrote:
> On Wed, Jun 04, 2014 at 02:47:43PM -0400, Vivek Goyal wrote:
> > Hmm..., Interesting. I never noticed it. So google search seems to say
> > that unuseable is also not wrong.
> 
> Nope, it seems more like "unuseable" is simply a very common misspelling
> which has managed to spread out uncontrollably, even in the kernel :).
> Both Oxford and Merriam-Webster know "unusable" as the only correct
> spelling.

Ok, given that you feel so strongly about it, I will change it next
version of patches. :-).

Thanks
Vivek
