Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaGWElC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:41:02 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:50623 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaGWElA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:41:00 -0400
MIME-Version: 1.0
Date: Wed, 23 Jul 2014 00:40:59 -0400
Message-ID: <CAPDOMVjNyAwo53Coz8MFuUs70M7j1e3QWprus5vGpTfAw=hspg@mail.gmail.com>
Subject: smp-cmp.c: CDFIXMES
From: Nick Krause <xerofoify@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@imgtec.com>, John Crispin <blogic@openwrt.org>,
        markos.chandras@imgtec.com, Steven.Hill@imgtec.com,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are the lines with  CDFIXME still needed? If not please tell me as I
will send in a patch removing these
two from this file in order to help you guys out :).
Cheers Nick
