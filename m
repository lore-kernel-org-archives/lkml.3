Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3F0IVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:21:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59456 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3F0IVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:21:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Simon Baatz <gmbnomis@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [04/26] ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page
References: <lsq.1372214158.657310117@decadent.org.uk>
	<878v1x4510.fsf@canonical.com> <20130626223554.GB25104@schnuecks.de>
Date: Thu, 27 Jun 2013 09:21:32 +0100
In-Reply-To: <20130626223554.GB25104@schnuecks.de> (Simon Baatz's message of
	"Thu, 27 Jun 2013 00:35:54 +0200")
Message-ID: <87zjucvu9f.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Baatz <gmbnomis@gmail.com> writes:

> Hi Ben, Luis,
>
> On Wed, Jun 26, 2013 at 10:04:11AM +0100, Luis Henriques wrote:
>> Ben Hutchings <ben@decadent.org.uk> writes:
>> 
>> > 3.2.48-rc1 review patch.  If anyone has any objections, please let me know.
>> >
>> > ------------------
>> >
>> > From: Simon Baatz <gmbnomis@gmail.com>
>> >
>> > commit 1bc39742aab09248169ef9d3727c9def3528b3f3 upstream.
>> 
>> Simon suggested Greg not to queue this patch for stable kernels as it
>> breaks no-MMU ARM configs.  He will provide a follow-up patch that
>> should go together with this one.
>
> Fortunately, the follow-up patch is upstream now. It is commit
> 63384fd0b1509acf522a8a8fcede09087eedb7df (ARM: 7772/1: Fix missing
> flush_kernel_dcache_page() for noMMU).
>
> Thus, please add that patch as well. If it is too late to do this, my
> suggestion would be to queue both of them together for the next cycle.

Thanks Simon, I'll queue both for the 3.5 kernel.

Cheers,
-- 
Luis
