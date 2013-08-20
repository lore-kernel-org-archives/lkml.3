Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3HTGx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:53:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42273 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab3HTGxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:53:25 -0400
Date: Tue, 20 Aug 2013 08:53:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dougthompson@xmission.com, bhelgaas@google.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/1] AMD64_EDAC: Fix incorrect wrap arounds due to left
 shift beyond 32 bits.
Message-ID: <20130820065322.GB12904@pd.tnic>
References: <1376958472-2150-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1376958472-2150-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 07:27:51PM -0500, Aravind Gopalakrishnan wrote:
> Aravind Gopalakrishnan (1):
>   AMD64_EDAC: Fix incorrect wrap arounds due to left shift beyond 32
>     bits.
> 
>  drivers/edac/amd64_edac.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Just a minor thing: when you send one patch only, you don't really need
the 0/1 email.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
