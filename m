Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaFEOJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:09:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52719 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaFEOJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:09:45 -0400
Date: Thu, 5 Jun 2014 16:07:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 03/13] kexec: Move segment verification code in a
 separate function
Message-ID: <20140605140746.GC16642@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-4-git-send-email-vgoyal@redhat.com>
 <20140604093254.GB4105@pd.tnic>
 <20140604184743.GC4406@redhat.com>
 <20140604203041.GF4105@pd.tnic>
 <20140605140506.GC17389@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140605140506.GC17389@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 10:05:06AM -0400, Vivek Goyal wrote:
> Ok, given that you feel so strongly about it, I will change it next
> version of patches. :-).

Hehe, thanks! :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
