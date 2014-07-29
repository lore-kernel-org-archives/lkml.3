Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaG2L6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:58:43 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51629 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaG2L6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:41 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/19] staging: comedi: amplc_pci230: tidy up a bit
Date: Tue, 29 Jul 2014 12:58:08 +0100
Message-Id: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tidy up the "amplc_pci230" driver a bit.  There are more changes to come
after this.  The only one of these that should alter the object code is
patch 06, which replaces a udelay() call with usleep_range().

01) staging: comedi: amplc_pci230: reformat a load of comments
02) staging: comedi: amplc_pci230: fix checkpatch line over 80
    characters
03) staging: comedi: amplc_pci230: logical continuations should be on
    the previous line
04) staging: comedi: amplc_pci230: blank lines aren't necessary before a
    close brace '}'
05) staging: comedi: amplc_pci230: alignment should match open
    parenthesis
06) staging: comedi: amplc_pci230: usleep_range is preferred over udelay
07) staging: comedi: amplc_pci230: remove unused settling time constants
08) staging: comedi: amplc_pci230: remove PCI230_ADC_CONV
09) staging: comedi: amplc_pci230: remove PCI230_TEST_BIT()
10) staging: comedi: amplc_pci230: add whitespace to register values
11) staging: comedi: amplc_pci230: don't begin line with binary operator
12) staging: comedi: amplc_pci230: omit '!= 0' from logical expressions
13) staging: comedi: amplc_pci230: remove unnecessary braces
14) staging: comedi: amplc_pci230: remove some indentation in
    pci230_ai_check_chanlist()
15) staging: comedi: amplc_pci230: no need for '&function'
16) staging: comedi: amplc_pci230: add whitespace to pci230_boards[]
17) staging: comedi: amplc_pci230: no need to initialize named members
    to zero
18) staging: comedi: amplc_pci230: tidy up stuct pci230_private
19) staging: comedi: amplc_pci230: remove some unnecessary parentheses

 drivers/staging/comedi/drivers/amplc_pci230.c | 1417 +++++++++++++------------
 1 file changed, 736 insertions(+), 681 deletions(-)
