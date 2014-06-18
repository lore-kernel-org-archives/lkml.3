Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaFRRkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:40:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaFRRkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:40:20 -0400
Date: Wed, 18 Jun 2014 13:39:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH 13/13] kexec: Support kexec/kdump on EFI systems
Message-ID: <20140618173933.GF15327@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-14-git-send-email-vgoyal@redhat.com>
 <20140618160607.GI24024@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618160607.GI24024@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 06:06:07PM +0200, Borislav Petkov wrote:
> Addomg linux-efi to CC for the efi bits. Please CC it on your next
> submission.

Sure I will. Thanks for reviewing the patches. I will get these ready
for next round of submission.

Thanks
Vivek
