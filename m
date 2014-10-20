Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaJTJxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:53:42 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:56177 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaJTJxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:53:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_Zhf73TXxAjBq_cCJB_oBC1Ff_ErN7TP4HsO-_BzhiPZkGQ@mail.gmail.com>
References: <CAJe_Zhf73TXxAjBq_cCJB_oBC1Ff_ErN7TP4HsO-_BzhiPZkGQ@mail.gmail.com>
Date: Mon, 20 Oct 2014 15:23:38 +0530
Message-ID: <CAJe_ZhcXTp6phuS=8nYuXTD3yUHsu7QKap85iVgfcZsrmOK59g@mail.gmail.com>
Subject: Re: [GIT PULL] New Mailbox framework for 3.18
From: Jassi Brar <jaswinder.singh@linaro.org>
To: torvalds@linux-foundation.org
Cc: Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Matt Porter <mporter@linaro.org>,
        LeyFoon Tan <lftan.linux@gmail.com>, "Anna, Suman" <s-anna@ti.com>,
        Bjorn Andersson <bjorn@kryo.se>, Mark Brown <broonie@linaro.org>,
        Kevin Hilman <khilman@linaro.org>, Andy Green <andy.green@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Alexandre Torgue <alexandre.torgue@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 October 2014 11:09, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> Hi Linus,
>
> A framework for Mailbox controllers and clients have been cooking for
> more than a year now. Everybody in the CC list had been copied on
> patchset revisions and most of them have made sounds of approval,
> though just one concrete Reviewed-by. The patchset has also been in
> linux-next for a couple of weeks now and no conflict has been
> reported. The framework has the backing of at least 5 platforms,
> though I can't say if/when they upstream their drivers (some
> businesses have 'changed').
>
>
> The following changes since commit 9a50aaefc1b896e734bf7faf3d085f71a360ce97:
>
>   Merge tag 'scsi-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2014-10-07
> 21:29:18 -0400)
>
> are available in the git repository at:
>
>
>   git://git.linaro.org/landing-teams/working/fujitsu/integration.git
> mailbox-for-linus
>
> for you to fetch changes up to 9f3e3cacb2ffdefe28c7cf490bf543e4dcb2770a:
>
>   dt: mailbox: add generic bindings (2014-10-08 10:39:42 +0530)
>
> ----------------------------------------------------------------
> Jassi Brar (3):
>       mailbox: Introduce framework for mailbox
>       doc: add documentation for mailbox framework
>       dt: mailbox: add generic bindings
>
> Suman Anna (1):
>       mailbox: rename pl320-ipc specific mailbox.h
>
>  .../devicetree/bindings/mailbox/mailbox.txt        |  38 ++
>  Documentation/mailbox.txt                          | 122 ++++++
>  MAINTAINERS                                        |   8 +
>  arch/arm/mach-highbank/highbank.c                  |   2 +-
>  drivers/cpufreq/highbank-cpufreq.c                 |   2 +-
>  drivers/mailbox/Makefile                           |   4 +
>  drivers/mailbox/mailbox.c                          | 465 +++++++++++++++++++++
>  drivers/mailbox/pl320-ipc.c                        |   2 +-
>  include/linux/mailbox_client.h                     |  46 ++
>  include/linux/mailbox_controller.h                 | 133 ++++++
>  include/linux/{mailbox.h => pl320-ipc.h}           |   0
>  11 files changed, 819 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt
>  create mode 100644 Documentation/mailbox.txt
>  create mode 100644 drivers/mailbox/mailbox.c
>  create mode 100644 include/linux/mailbox_client.h
>  create mode 100644 include/linux/mailbox_controller.h
>  rename include/linux/{mailbox.h => pl320-ipc.h} (100%)
>
Hi Linus,
  While I was speculating on the reasons why you were not merging the
patchset - not enough Acked-Bys, you want it via asoc, my git server
down (I am not aware) or you just forgot in the unlikely case - I
missed the window.
 There are couple of platforms waiting for the api to get upstream and
now I have the devs on my back. Assuming I messed up the pull request
somehow, may I know how?

Thanks
-Jassi
