Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3IMLEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:04:36 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36938 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3IMLEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:04:34 -0400
Message-ID: <5232F139.4080508@gmail.com>
Date: Fri, 13 Sep 2013 13:04:25 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: bcache <linux-bcache@vger.kernel.org>, linux-kernel@vger.kernel.org,
        ubuntu-devel@lists.ubuntu.com
Subject: [ANN] Ubuntu PPA for bcache-tools and blocks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I've published various bcache-related packages to

https://launchpad.net/~g2p/+archive/storage/

The packages are built for saucy and raring, and can be
added with

    sudo add-apt-repository ppa:g2p/storage
    sudo apt-get update
    sudo apt-get install bcache-tools blocks

bcache is a hybrid caching layer that speeds up HDDs
with SSDs; it was merged in Linux 3.10.  Backported
Ubuntu kernels are available at

http://kernel.ubuntu.com/~kernel-ppa/mainline/

bcache-tools contains udev and initramfs integration and
some command-line tools.

blocks is a conversion tool that can convert block devices
to bcache and lvm.  Usage is described here:

https://github.com/g2p/blocks#bcache-conversion

This release of blocks adds a maintboot mode that can
convert root filesystems to bcache without a live cd.
