Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaFEOFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:05:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaFEOE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:04:59 -0400
Date: Thu, 5 Jun 2014 10:04:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: WANG Chao <chaowang@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, mjg59@srcf.ucam.org,
        Greg Kroah-Hartman <greg@kroah.com>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, dyoung@redhat.com, bhe@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in
 kernel loading
Message-ID: <20140605140416.GB17389@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <20140603131203.GA23395@redhat.com>
 <20140604092214.GA17528@dhcp-17-89.nay.redhat.com>
 <20140604175031.GA4406@redhat.com>
 <CAHO5Pa0dxpq7YNe5eUMPE9Mn5m7XCnB1C5mZxrvt2-OqOpVZAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHO5Pa0dxpq7YNe5eUMPE9Mn5m7XCnB1C5mZxrvt2-OqOpVZAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:39:10PM +0200, Michael Kerrisk wrote:
> Vivek,
> 
> As per Documentation/SubmitChecklist , please CC linux-api@ on patces
> that change the ABI/API. See
> https://www.kernel.org/doc/man-pages/linux-api-ml.html.

Hi Michael,

Sorry, I did not notice that. I will CC linux-api@ in next version of
patches in patches which introduce new systemcal..

> 
> Also, is there some draft man page for this new system call?

No, there is none yet. In fact I don't see a man page for old kexec
system call either kexec_load().

Do you want me to write man page for this new syscall?

Thanks
Vivek
