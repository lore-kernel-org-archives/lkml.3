Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3GLAZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:25:07 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54233 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab3GLAZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 20:25:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130711220545.542911892@linuxfoundation.org>
References: <20130711220545.542911892@linuxfoundation.org>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 11 Jul 2013 20:24:33 -0400
X-Google-Sender-Auth: fJ8kqpl4t0MoAOVDyU54rWXm918
Message-ID: <CAP=VYLqgAF=RL9BcemhQH_qN8c8n9vud2QfPkMskH-rBMd35UA@mail.gmail.com>
Subject: Re: [ 00/11] 3.4.53-stable review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 6:11 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.4.53 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Jul 13 22:04:03 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.53-rc1.gz

Just happened to notice the v3.0 in the path vs. the 3.4 version.
Wasn't sure that was intentional or not, so figured I'd mention it.

P.
--

> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 3.4.53-rc1
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "sched: Add missing call to calc_load_exit_idle()"
>
> Ben Hutchings <ben@decadent.org.uk>
>     SCSI: sd: Fix parsing of 'temporary ' cache mode prefix
>
> J. Bruce Fields <bfields@redhat.com>
>     nfsd4: fix decoding of compounds across page boundaries
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information
>
> Kees Cook <keescook@chromium.org>
>     crypto: sanitize argument for format string
>
> Kees Cook <keescook@chromium.org>
>     block: do not pass disk names as format strings
>
> Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
>     hpfs: better test for errors
>
> Kees Cook <keescook@chromium.org>
>     charger-manager: Ensure event is not used as format string
>
> Jonathan Salwan <jonathan.salwan@gmail.com>
>     drivers/cdrom/cdrom.c: use kzalloc() for failing hardware
>
> Tyler Hicks <tyhicks@canonical.com>
>     libceph: Fix NULL pointer dereference in auth client code
>
>
> -------------
>
> Diffstat:
>
>  MAINTAINERS                        | 1 +
>  Makefile                           | 4 ++--
>  block/genhd.c                      | 2 +-
>  crypto/algapi.c                    | 3 ++-
>  drivers/block/nbd.c                | 3 ++-
>  drivers/cdrom/cdrom.c              | 2 +-
>  drivers/power/charger-manager.c    | 2 +-
>  drivers/scsi/osd/osd_uld.c         | 2 +-
>  drivers/scsi/sd.c                  | 2 +-
>  drivers/tty/serial/8250/8250_pci.c | 4 ----
>  fs/hpfs/map.c                      | 3 ++-
>  fs/hpfs/super.c                    | 8 +++++++-
>  fs/nfsd/nfs4xdr.c                  | 2 +-
>  kernel/time/tick-sched.c           | 1 -
>  net/ceph/auth_none.c               | 6 ++++++
>  15 files changed, 28 insertions(+), 17 deletions(-)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
