Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3HATTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:19:40 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:57904 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab3HATTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:19:39 -0400
MIME-Version: 1.0
Date: Thu, 1 Aug 2013 21:19:39 +0200
Message-ID: <CAPBO7TZhqkZ9vArSBiUO78f-9M=FGLe1StyR-6Y7Zv3drtviZw@mail.gmail.com>
Subject: About sensors (temperature) and 3.10.x kernels
From: Josep Lladonosa <jlladono@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have just joined this list to point out that

using 3.11.0-rcX brancheskernel (x86_64 compilation) the temperature
sensors work (as in the 3.2.x, 3.8.x),


BUT 3.10.x kernel versions do not let run applications that read
sensors. I am using xfce4-sensors-plugin (under Debian) and it
coredumps under this kernel version. I have seen this at least in
3.10.4...

I wish it helps...


-- 
--
Salutacions...Josep
--
