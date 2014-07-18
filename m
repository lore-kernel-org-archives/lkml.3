Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbaGRDqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:46:34 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45805 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759677AbaGRDqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:46:33 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: sfr@canb.auug.org.au, rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/linux-next] Documentation:DocBook: Fix file paths in gadget.tmpl
Date: Fri, 18 Jul 2014 12:46:08 +0900
Message-Id: <1405655169-23804-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.1.537.g81e776d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Started on linux-next 2014-07-17, commit 5ed4ac73e5975b 
was added. This patch moves file location from 
driver/usb/gadget to driver/usb/gadget/function.
Because of this change, make xmldocs started to fail,
because the gadget.tmpl file still have an old paths.

Masanari Iida (1):
  Documentation:Docbook: Fix file locations in gadget.tmpl

 Documentation/DocBook/gadget.tmpl | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.0.1.537.g81e776d

