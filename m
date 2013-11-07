Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3KGJDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:03:36 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:34689 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3KGJD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:03:29 -0500
Date: Thu, 7 Nov 2013 10:03:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        X86 ML <x86@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: kernel bugzilla #64531: intel microcode information
Message-ID: <20131107090325.GB403@gmail.com>
References: <527B28BB.9070400@infradead.org>
 <201311070943.40134.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201311070943.40134.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:

> On Thursday 07 of November 2013, Randy Dunlap wrote:
> > Re: https://bugzilla.kernel.org/show_bug.cgi?id=64531
> > 
> > 
> > arch/x86/Kconfig line 1053 (+/-), help section in CONFIG_MICROCODE_INTEL,
> > says:
> > 
> > For latest news and information on obtaining all the required
> > Intel ingredients for this driver, check:
> > <http://www.urbanmyth.org/microcode/>
> > 
> > ==> 404  Page not found
> > 
> > 
> > Is there a good replacement for this information or should we just
> > delete that help text?
> 
> For downloading
>  http://downloadcenter.intel.com/ -> search for "processor microcode data 
> file"

How about:

  http://www.intel.com/content/www/us/en/search.html?keyword=linux+microcode+data+file

? That, by the looks of it, appears to be a reasonably stable URL.

Thanks,

	Ingo
