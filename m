Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab3KGFob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:44:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45594 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3KGFoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:44:30 -0500
Message-ID: <527B28BB.9070400@infradead.org>
Date: Wed, 06 Nov 2013 21:44:27 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Subject: kernel bugzilla #64531: intel microcode information
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re: https://bugzilla.kernel.org/show_bug.cgi?id=64531


arch/x86/Kconfig line 1053 (+/-), help section in CONFIG_MICROCODE_INTEL, says:

For latest news and information on obtaining all the required
Intel ingredients for this driver, check:
<http://www.urbanmyth.org/microcode/>

==> 404  Page not found


Is there a good replacement for this information or should we just
delete that help text?


thanks,

-- 
~Randy
