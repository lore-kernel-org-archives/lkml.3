Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaFPVNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:13:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48809 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356AbaFPVNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:13:39 -0400
Date: Mon, 16 Jun 2014 23:13:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in
 kernel loading
Message-ID: <20140616211328.GK8170@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:06:49AM -0400, Vivek Goyal wrote:
> This patch series does not do kernel signature verification yet. I
> plan to post another patch series for that. Now bzImage is already
> signed with PKCS7 signature I plan to parse and verify those
> signatures.

Btw, do you have a brief outline on how you are going to do the
extension to signature verification? Nothing formal, just enough of an
outline that I can see where in the flow it will be plugged in.

I was wondering how the whole signature signing and verification will
be done, i.e., where do I get the signature, how and who will verify it
(I'm guessing the purgatory code), etc, etc.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
