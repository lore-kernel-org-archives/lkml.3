Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3DBEPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:15:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:51036 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab3DBEPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:15:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,391,1363158000"; 
   d="scan'208";a="312138419"
From: "Sun, Yi" <yi.sun@intel.com>
To: "davej@redhat.com" <davej@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Fail to build trinity
Thread-Topic: Fail to build trinity
Thread-Index: Ac4uhi1Z2bMzvEifR1e82cUD7oO9qAAROMiAACNgf6A=
Date: Tue, 2 Apr 2013 04:15:03 +0000
Message-ID: <D9F66AA509623343B6A9A3D4502D5A520FF22632@SHSMSX102.ccr.corp.intel.com>
References: <D9F66AA509623343B6A9A3D4502D5A520FF21B43@SHSMSX102.ccr.corp.intel.com>
 <20130401192133.GB30182@redhat.com>
In-Reply-To: <20130401192133.GB30182@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alright, done.

Thank you, Dave.

Thanks
    --Sun, Yi


> -----Original Message-----
> From: davej@redhat.com [mailto:davej@redhat.com]
> Sent: Tuesday, April 02, 2013 3:22 AM
> To: Sun, Yi
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Fail to build trinity
> 
> On Mon, Apr 01, 2013 at 03:09:09AM +0000, Sun, Yi wrote:
>  > Hi Dave,
>  >
>  > I'm a newer for trinity. Apologize for my foolish question. :)  >  > But I got
> the source with command: "git clone git://git.codemonkey.org.uk/trinity".
> While running ./configure.sh, got following failure:
>  > [root@x-ivb8 trinity]# ./configure.sh  > [*] Checking system headers.
>  > [*] Checking if pppox can use pppol2tpin6..  [NO]  > [*] Checking if pppox
> can use pppol2tv3..  [NO]  > [*] Checking if pppox can use pptp..  [NO]  > [*]
> Checking if llc can use LLC_OPT_PKTINFO..  [YES]  > [*] Checking if glibc
> headers provide termios2..  [NO]  > [*] Checking linux/caif/caif_socket.h
> exists...  [YES]  > [*] Checking linux/if_alg.h exists...  [YES]  > [*] Checking
> linux/rds.h exists...  [YES]  > [*] Checking linux/vfio.h exists...  [NO]  > [*]
> Checking linux/btrfs.h exists...  [NO]  > [*] Checking drm/exynos_drm.h
> exists...  [NO]  > [*] Checking sound/compress_offload.h exists...  [NO]  >
> [*] Checking linux/vhost.h exists...  [YES]  >  > It seems I'm missing dozens
> of header files. So could you please guide me how to get those header files or
> some other libraries?
> 
> They aren't actually failures.
> 
> It should still compile even though it doesn't find all the headers.
> You just won't be able to fuzz those specific functions because your headers
> your distro puts in /usr/include don't have definitions for them.
> 
>  > BTW, the mailing list
> linux-kernel@vger.kernel.org<mailto:linux-kernel@vger.kernel.org> doesn't
> work.
> 
> Did you mean trinity@vger.kernel.org ? it seems to be working fine for others.
> 
> 	Dave

