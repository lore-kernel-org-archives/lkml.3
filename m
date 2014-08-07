Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaHGUJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:09:12 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:63912 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaHGUJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:09:09 -0400
Date: Thu, 7 Aug 2014 21:09:06 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, catalin.marinas@arm.com,
        will.deacon@arm.com, matt.fleming@intel.com, ard.biesheuvel@linaro.org,
        msalter@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Message-ID: <20140807200906.GH15082@console-pimps.org>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
 <20140806130623.GI4179@bivouac.eciton.net>
 <20140806132021.GB15082@console-pimps.org>
 <20140806132941.GJ4179@bivouac.eciton.net>
 <20140806140155.GC15082@console-pimps.org>
 <20140807012708.GA20295@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807012708.GA20295@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug, at 09:27:09AM, Dave Young wrote:
> 
> As for Xen and SGI people? I have not been following all the efi threads
> so I'm not sure who exactly I should cc, could you tell me? 

For Xen, Daniel Kiper <daniel.kiper@oracle.com> 

For SGI, Russ Anderson <rja@sgi.com> and Alex Thorlton
<athorlton@sgi.com>.

-- 
Matt Fleming, Intel Open Source Technology Center
