Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab3CGLHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:07:04 -0500
Received: from 8bytes.org ([85.214.48.195]:48399 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255Ab3CGLHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:07:02 -0500
Date: Thu, 7 Mar 2013 12:06:59 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] buildtar: Add ARCH to the archive name
Message-ID: <20130307110659.GC22602@8bytes.org>
References: <1362557147-14393-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362557147-14393-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Mar  7 12:07:00 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 513874d423678364715335
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 09:05:47AM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> When dealing with multiple sub-arches (like 32- and 64-bit on x86, for
> example) generating a bunch of kernel tar archives with the same name
> but for different sub-arches could get confusing and error-prone. Also,
> the build process could overwrite otherwise unrelated builds and you
> probably don't want that. So, add the architecture to the archive name
> for more clarity and less shoot-yourself-in-the-foot practices.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>

Good idea, but I already hear people yelling about their scripts that
break with this change :)


	Joerg


