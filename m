Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaIIAGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:06:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbaIIAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:06:34 -0400
Date: Mon, 8 Sep 2014 17:06:28 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eeepc-laptop: remove possible use of uninitialized value
Message-ID: <20140909000628.GC5835@vmdeb7>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 12:53:25AM +0200, Frans Klaver wrote:
> In store_sys_acpi, if count equals zero, or parse_arg()s sscanf call
> fails, 'value' remains possibly uninitialized. In that case 'value'
> shouldn't be used to produce the store_sys_acpi()s return value.
> 
> Only test the return value of set_acpi() if we can actually call it.
> Return rv otherwise.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>


FYI, based on recent discussion with Paul, Greg, and Frans, I am not picking
this up, but waiting for a next rev from Frans, possibly including Paul's
original patch.

-- 
Darren Hart
Intel Open Source Technology Center
