Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaAUOYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:24:43 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:56282 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbaAUOYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:24:42 -0500
Date: Tue, 21 Jan 2014 09:24:37 -0500
From: Matt Porter <mporter@linaro.org>
To: Linux USB List <linux-usb@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanislaw Wadas <s.wadas@samsung.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: libusbg 0.1.0 (formerly libgadget)
Message-ID: <20140121142437.GH31176@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libusbg 0.1.0 is released. libusbg is a library that provides a C API to
the kernel USB gadget configfs API. It simplifies creation and
management of USB gadget devices from C applications.

Get it at:

	git://github.com/libusbg/libusbg.git

API docs at:

	http://libusbg.github.com/group__libusbg.html
	http://libusbg.github.com/examples.html

Changes since libgadget 0.0.1:

	- libusbg now has a new name to avoid conflicts
	  with an existing libgadget libary
	- use the standard /sys/kernel/config mount path
	  in examples
	- a new project home on github

Going forward we have a couple contributors with clean up and bug
fixes that will be rolled into libusbg once comments are addressed.
Support for FunctionFS (merged for 3.14) will also be added.

-Matt
