Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaH1PRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:17:01 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:65196 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaH1PRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:17:00 -0400
MIME-Version: 1.0
Date: Thu, 28 Aug 2014 17:16:58 +0200
Message-ID: <CAG-aW06Q9VVyW-atZEsURs0rfjysdEbxb_dC4Tm3K-tZg++tQg@mail.gmail.com>
Subject: linux-3.16.2 queue (3.16.1+)
From: Matt <jackdachef@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,


please consider adding the following 2 patches to 3.16.2:

Jan Kara (1):
      reiserfs: Fix use after free in journal teardown

Jeff Mahoney (1):
      reiserfs: fix corruption introduced by balance_leaf refactor



Reason/Related:

https://bugzilla.kernel.org/show_bug.cgi?id=83121

https://bugzilla.kernel.org/show_bug.cgi?id=83321

http://forums.gentoo.org/viewtopic-t-998538-postdays-0-postorder-asc-start-0.html


Many thanks in advance


Kind Regards

Matt
