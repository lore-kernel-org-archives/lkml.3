Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3FZNF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:05:26 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64646 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3FZNFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:05:24 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 26 Jun 2013 14:05:04 +0100
X-Google-Sender-Auth: 2YV51x320jbg2yXnSSYOoaruKro
Message-ID: <CACxGe6t8KvnUfm7bt3-8+9d9KXwz1W4dQB+y+m0D75DRkMCGGA@mail.gmail.com>
Subject: [GIT PULL] GPIO regression fix for omap1 for v3.10-rc
To: Tony Lindgren <tony@atomide.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

It took a while to work out the correct solution to this regression.
It is sorted now. This branch was constructed and tested by Tony. I've
verified that it builds and signed the tag. Please pull into v3.10.

g.

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/gpio-for-linus

for you to fetch changes up to 397eada946712b90e0620c378b366bcc6c98c9f6:

  gpio/omap: don't use linear domain mapping for OMAP1 (2013-06-25
23:13:40 -0700)

----------------------------------------------------------------
Fix for omap1 GPIO breaking regression

----------------------------------------------------------------
Javier Martinez Canillas (1):
      gpio/omap: don't use linear domain mapping for OMAP1

 drivers/gpio/gpio-omap.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

On Wed, Jun 26, 2013 at 8:05 AM, Tony Lindgren <tony@atomide.com> wrote:
> The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:
>
>   Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/omap-for-v3.10/gpio-signed
>
> for you to fetch changes up to 397eada946712b90e0620c378b366bcc6c98c9f6:
>
>   gpio/omap: don't use linear domain mapping for OMAP1 (2013-06-25 23:13:40 -0700)
>
> ----------------------------------------------------------------
> Fix for omap1 GPIO breaking regression.
>
> ----------------------------------------------------------------
> Javier Martinez Canillas (1):
>       gpio/omap: don't use linear domain mapping for OMAP1
>
>  drivers/gpio/gpio-omap.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
