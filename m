Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581Ab3DATWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:22:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759507Ab3DATVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:21:36 -0400
Date: Mon, 1 Apr 2013 15:21:33 -0400
From: "davej@redhat.com" <davej@redhat.com>
To: "Sun, Yi" <yi.sun@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fail to build trinity
Message-ID: <20130401192133.GB30182@redhat.com>
Mail-Followup-To: "davej@redhat.com" <davej@redhat.com>,
	"Sun, Yi" <yi.sun@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <D9F66AA509623343B6A9A3D4502D5A520FF21B43@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D9F66AA509623343B6A9A3D4502D5A520FF21B43@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 03:09:09AM +0000, Sun, Yi wrote:
 > Hi Dave,
 > 
 > I'm a newer for trinity. Apologize for my foolish question. :)
 > 
 > But I got the source with command: "git clone git://git.codemonkey.org.uk/trinity". While running ./configure.sh, got following failure:
 > [root@x-ivb8 trinity]# ./configure.sh
 > [*] Checking system headers.
 > [*] Checking if pppox can use pppol2tpin6..  [NO]
 > [*] Checking if pppox can use pppol2tv3..  [NO]
 > [*] Checking if pppox can use pptp..  [NO]
 > [*] Checking if llc can use LLC_OPT_PKTINFO..  [YES]
 > [*] Checking if glibc headers provide termios2..  [NO]
 > [*] Checking linux/caif/caif_socket.h exists...  [YES]
 > [*] Checking linux/if_alg.h exists...  [YES]
 > [*] Checking linux/rds.h exists...  [YES]
 > [*] Checking linux/vfio.h exists...  [NO]
 > [*] Checking linux/btrfs.h exists...  [NO]
 > [*] Checking drm/exynos_drm.h exists...  [NO]
 > [*] Checking sound/compress_offload.h exists...  [NO]
 > [*] Checking linux/vhost.h exists...  [YES]
 > 
 > It seems I'm missing dozens of header files. So could you please guide me how to get those header files or some other libraries?

They aren't actually failures.

It should still compile even though it doesn't find all the headers.
You just won't be able to fuzz those specific functions because your
headers your distro puts in /usr/include don't have definitions for them.

 > BTW, the mailing list linux-kernel@vger.kernel.org<mailto:linux-kernel@vger.kernel.org> doesn't work.

Did you mean trinity@vger.kernel.org ? it seems to be working fine for others.

	Dave

