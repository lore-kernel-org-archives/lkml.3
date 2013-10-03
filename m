Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3JCStv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:49:51 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53078 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3JCStu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:49:50 -0400
MIME-Version: 1.0
Date: Fri, 4 Oct 2013 00:19:50 +0530
Message-ID: <CAFqkpAYZCrHgxsFJ+3nNzu=RuyFX0ao9ivGb_H4J1n+u01h4qQ@mail.gmail.com>
Subject: Classifying user and kernel pages
From: Piyus Kedia <piyuskedia@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Does anybody know if there is a way in Linux Kernel to find whether a
physical page is a user page or it is kernel page. A kernel page is
only accessed by kernel and it doesn't belong to any user process.

Thanks,
Piyus
