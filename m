Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaLVRua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:50:30 -0500
Received: from d.mail.sonic.net ([64.142.111.50]:37790 "EHLO d.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbaLVRu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:50:29 -0500
X-Greylist: delayed 787 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2014 12:50:28 EST
Message-ID: <54985686.7080609@freebsd.org>
Date: Mon, 22 Dec 2014 09:36:06 -0800
From: Nathan Whitehorn <nwhitehorn@freebsd.org>
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Geoff Levand <geoff@infradead.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andre Heider <a.heider@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: powerpc: platforms: ps3: repository.c:  Remove
 unused function
References: <1419087601-4889-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <1419269161.3786.4.camel@infradead.org>
In-Reply-To: <1419269161.3786.4.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Sonic-CAuth: UmFuZG9tSVao4qoXawLUm/NYHENNKIOg2dlUdsjPfPKgXA7D3Iq47wgdLE/Rc8A+ta66lqFa+dy6q7aYax4gHIVbEMrPgjnZoj7BzED+rP0=
X-Sonic-ID: C;GLCRAgGK5BGKA1G2qJ4NOg== M;aIEBAwGK5BGKA1G2qJ4NOg==
X-Spam-Flag: No
X-Sonic-Spam-Details: 0.0/5.0 by cerberusd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/22/14 09:26, Geoff Levand wrote:
> On Sat, 2014-12-20 at 16:00 +0100, Rickard Strandqvist wrote:
>> Remove the function ps3_repository_write_highmem_info() that is not used anywhere.
> NAK
>
> ps3_repository_write_highmem_info() is needed by otheros++.  What we
> need is a kernel patch to add the highmem info to the repository once it
> is known.
>
> These ps3_repository_write_highmem routines are also the only
> documentation the freeBSD port has as to how the highmem info is (should
> be) saved in the repository.
>
> -Geoff
>
>

Yes, we really need this for FreeBSD since that port uses the repository 
directly instead of FDT. Thanks for noticing this. We could adapt 
FreeBSD to use FDT (this is the only non-device-tree PowerPC port), but 
there hasn't been any reason to do that thus far given the availability 
of the repository information.
-Nathan
