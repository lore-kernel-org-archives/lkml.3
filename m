Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3KIFfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 00:35:40 -0500
Received: from top.free-electrons.com ([176.31.233.9]:58081 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000Ab3KIFfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 00:35:37 -0500
Message-ID: <527DC99C.2060703@free-electrons.com>
Date: Sat, 09 Nov 2013 06:35:24 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Dixit, Ashutosh" <ashutosh.dixit@intel.com>,
        "Kharche, Harshavardhan R" <harshavardhan.r.kharche@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Rao, Nikhil" <nikhil.rao@intel.com>,
        "Dutt, Sudeep" <sudeep.dutt@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] misc: mic: dead code removal and minor cleanup
References: <1383970422-16973-1-git-send-email-michael.opdenacker@free-electrons.com> <6DC2528F945B4149AB6566DFB5F22ED38AAA142A@ORSMSX109.amr.corp.intel.com>
In-Reply-To: <6DC2528F945B4149AB6566DFB5F22ED38AAA142A@ORSMSX109.amr.corp.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashutosh,

Thanks for your review!

On 11/09/2013 06:06 AM, Dixit, Ashutosh wrote:
> Hi Michael
>
> Thanks for your mail. However, the dead code has resulted from
> another bug in the code, we should be decrementing retry instead
> of i. The same bug occurs in several other places in the code too.
>
> So I would say don't apply this patch. We are planning a series of
> patches to fix other issues in the code when the 3.13 merge window
> closes and will include this fix too and include you in "Reported-by".
That's fine for me. Good to know that this issue is being taken care of.

Thanks for yor work!

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

