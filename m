Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3DXNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 09:25:29 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:59357 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3DXNZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 09:25:27 -0400
Subject: Re: [PATCH V6 3/3] efi: Distinguish between "remaining space" and
 actually used space
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1366804640.13667.27.camel@x230.lan>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
	 <1366798111.23707.293.camel@linux-s257.site>
	 <1366798497.13667.25.camel@x230.lan>
	 <1366801173.23707.323.camel@linux-s257.site>
	 <1366804640.13667.27.camel@x230.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Apr 2013 21:23:56 +0800
Message-ID: <1366809836.23707.331.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-04-24 於 11:57 +0000，Matthew Garrett 提到：
> On Wed, 2013-04-24 at 18:59 +0800, joeyli wrote:
> 
> > Then why we don't just remove the "remaining_size" condition but only
> > monitor the active_size should not larger then 1/2 storage_size?
> 
> If we calculate active_size as using more than 50% of the storage space
> but remaining_size says we still have more than 50% available, we should
> trust remaining_size instead of active_size.
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org

That makes sense because BIOS base on remaining_size to trigger garbage
collection.

Thanks for your clarification!

Joey Lee


