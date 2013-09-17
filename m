Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab3IQDGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 23:06:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58879 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751678Ab3IQDGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 23:06:17 -0400
Message-ID: <5237C726.9070002@free-electrons.com>
Date: Tue, 17 Sep 2013 05:06:14 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Ungerer <gregungerer@westnet.com.au>
CC: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: remove unused Kconfig parameters
References: <1378468779-3289-1-git-send-email-michael.opdenacker@free-electrons.com> <523798BD.9010108@westnet.com.au>
In-Reply-To: <523798BD.9010108@westnet.com.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 09/17/2013 01:48 AM, Greg Ungerer wrote:
> Hi Michael,
>
> On 06/09/13 21:59, Michael Opdenacker wrote:
>> This patch proposes to remove the UC5282 and UC5272 kernel configuration
>> parameters defined in arch/m68k/Kconfig.machine,
>> but used nowhere in the makefiles and source code.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> This change is a subset of c065edde ("remove 16 unused boards in
> Kconfig.machine") by Pauk Bolle. And that is in 3.12-rc1.
Awesome! Thank you very much for the good news, and for not applying the
same change twice. Pfooh, this would have created anti-kconfig
parameters. Scary. ;)

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

