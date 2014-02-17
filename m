Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaBQAmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:42:18 -0500
Received: from seketeli.net ([94.23.218.202]:42276 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaBQAmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:42:17 -0500
Date: Mon, 17 Feb 2014 01:43:08 +0100
From: Apelete Seketeli <apelete@seketeli.net>
To: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2] Add documentation on writing an musb glue layer
Message-ID: <20140217004308.GH4177@amegan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Debian GNU/Linux 7
X-URL: http://apelete.seketeli.net
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Following a few patches already in tree that add support for the USB
device controller of the Ingenic JZ4740 MIPS SoC, I documented the
process of writing an MUSB glue layer.
The JZ4740 MUSB controller offers a basic feature set, which makes the
glue layer implementation more simple than most current glue layers in
tree.

The patch that comes as a follow-up of this message is an attempt to
provide a step-by-step walk-through of the process of writing an MUSB
glue layer.

Changes since v1:
  - add a line in legal notice paragraph to refer to COPYING
    file in kernel source tree.

I'm also adding linux-usb in Cc: to let people there know about
this just in case it went under the radar before.
Please review and let me know if there's something that need to be
fixed in the document.

Changes were rebased on top of Linus Torvalds' tree, with the
documentation built and tested successfully.

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3

are available in the git repository at:

  git://git.seketeli.net/~apelete/linux.git writing-musb-glue-layer

Apelete Seketeli (1):
  documentation: docbook: document process of writing an musb glue
    layer

 Documentation/DocBook/Makefile                     |    3 +-
 Documentation/DocBook/writing_musb_glue_layer.tmpl |  873 ++++++++++++++++++++
 2 files changed, 875 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/DocBook/writing_musb_glue_layer.tmpl

-- 
        Apelete
