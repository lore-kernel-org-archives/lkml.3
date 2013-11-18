Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3KRBTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 20:19:16 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:43130 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3KRBTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 20:19:11 -0500
MIME-Version: 1.0
Date: Mon, 18 Nov 2013 09:19:10 +0800
Message-ID: <CAK2Ky6zUfngvgKAaqNzTN9KPY2zgir3Yevj-r_=wWq=1RN3yAw@mail.gmail.com>
Subject: list_head and lock?
From: =?GB2312?B?uqvA2g==?= <bonben1989@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when we delete,add,search,amend the list_head,should we use spinlock
or rcu in case of conflicit to list_head???

Thank you!
