Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3DOHhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:37:01 -0400
Received: from ozlabs.org ([203.10.76.45]:52402 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab3DOHhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:37:00 -0400
Date: Mon, 15 Apr 2013 17:36:58 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jkenisto@linux.vnet.ibm.com,
        mahesh@linux.vnet.ibm.com, anton@samba.org
Subject: Re: [PATCH 0/8] Nvram-to-pstore
Message-ID: <20130415073657.GD30156@concordia>
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:50:47PM +0530, Aruna Balakrishnaiah wrote:
> Currently the kernel provides the contents of p-series NVRAM only as a
> simple stream of bytes via /dev/nvram, which must be interpreted in user
> space by the nvram command in the powerpc-utils package.  This patch set
> exploits the pstore subsystem to expose each partition in NVRAM as a
> separate file in /dev/pstore. For instance Oops messages will stored in a
> file named [dmesg-nvram-2].

Please try to fold some of that info into the commit messages for actual
patches. The 0th patch is lost when we commit the series into git.

Also all your patches should have a subject starting with
"powerpc/pseries:".

cheers
