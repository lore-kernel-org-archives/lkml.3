Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaDNUK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:10:29 -0400
Received: from seketeli.net ([94.23.218.202]:56448 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaDNUK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:10:26 -0400
Date: Mon, 14 Apr 2014 22:10:28 +0200
From: Apelete Seketeli <apelete@seketeli.net>
To: Felipe Balbi <balbi@ti.com>, Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        David Fries <David@Fries.net>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Ben Hutchings <ben@decadent.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH v2] Add documentation on writing an musb glue layer
Message-ID: <20140414201028.GZ22445@amegan>
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

With 3.15-rc1 now released, please consider this for merge and let me
know if there's something that need to be fixed in the document.

Changes were rebased on top of Linus Torvalds' tree, with the
documentation built and tested successfully.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1

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
