Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3GKWO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:14:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab3GKWLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:11:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/11] 3.4.53-stable review
Date: Thu, 11 Jul 2013 15:11:00 -0700
Message-Id: <20130711220545.542911892@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.53 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jul 13 22:04:03 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.53-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.53-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "sched: Add missing call to calc_load_exit_idle()"

Ben Hutchings <ben@decadent.org.uk>
    SCSI: sd: Fix parsing of 'temporary ' cache mode prefix

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix decoding of compounds across page boundaries

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information

Kees Cook <keescook@chromium.org>
    crypto: sanitize argument for format string

Kees Cook <keescook@chromium.org>
    block: do not pass disk names as format strings

Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
    hpfs: better test for errors

Kees Cook <keescook@chromium.org>
    charger-manager: Ensure event is not used as format string

Jonathan Salwan <jonathan.salwan@gmail.com>
    drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Tyler Hicks <tyhicks@canonical.com>
    libceph: Fix NULL pointer dereference in auth client code


-------------

Diffstat:

 MAINTAINERS                        | 1 +
 Makefile                           | 4 ++--
 block/genhd.c                      | 2 +-
 crypto/algapi.c                    | 3 ++-
 drivers/block/nbd.c                | 3 ++-
 drivers/cdrom/cdrom.c              | 2 +-
 drivers/power/charger-manager.c    | 2 +-
 drivers/scsi/osd/osd_uld.c         | 2 +-
 drivers/scsi/sd.c                  | 2 +-
 drivers/tty/serial/8250/8250_pci.c | 4 ----
 fs/hpfs/map.c                      | 3 ++-
 fs/hpfs/super.c                    | 8 +++++++-
 fs/nfsd/nfs4xdr.c                  | 2 +-
 kernel/time/tick-sched.c           | 1 -
 net/ceph/auth_none.c               | 6 ++++++
 15 files changed, 28 insertions(+), 17 deletions(-)


