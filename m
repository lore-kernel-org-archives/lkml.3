Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaLPJ0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:26:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50488 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLPJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:26:37 -0500
Date: Tue, 16 Dec 2014 12:26:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: devel@driverdev.osuosl.org, Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Drokin <oleg.drokin@intel.com>, Greg Donald <gdonald@gmail.com>,
        HPDD-discuss@ml01.01.org
Subject: Re: [PATCH] staging: lustre: lustre: osc: lproc_osc.c: Fix for
 possible null pointer dereference
Message-ID: <20141216092613.GF4856@mwanda>
References: <1418596638-24646-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141215102502.GB4856@mwanda>
 <CAFo99gZXxEgZMgZ4Vc0yKjm8AYdrGTkZZ3Yr4j_HNuPEPUUFbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gZXxEgZMgZ4Vc0yKjm8AYdrGTkZZ3Yr4j_HNuPEPUUFbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:07:19AM +0100, Rickard Strandqvist wrote:
> Hi Dan
> 
> Quite right! Had to try it.
> 
> Do nothing then?
> But you must agree that it is still ugly and confusing code.
> 

Yes.  I agree that it's confusing.  I also suspect that "obd" is never
NULL but I haven't actually looked and these things are sometimes
complicated to verify.

I fine with merging the patch as a cleanup.

Smatch has code to not warn about these but it's not 100% correct so
it still warns sometimes when it shouldn't.

regards,
dan carpenter

