Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaGOSDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:03:34 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:40746 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaGOSDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:03:33 -0400
MIME-Version: 1.0
From: Alexei Fedotov <alexei.fedotov@gmail.com>
Date: Tue, 15 Jul 2014 21:55:03 +0400
Message-ID: <CAGc_3jE=oECerrgPWpHt=oLAEBCJ+jmfsaEx7=qbzurBJxqz-Q@mail.gmail.com>
Subject: Where in the code mmap + MAP_ANONYMOUS clears returned pages?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys,

I look into mmap.c code [1] and try to understand where anonymous
memory mapping (mmap + MAP_ANONYMOUS) sets memory to zero. My best
guess is I should dig that somewhere in mmap_region.

Could you please help me locating the code which makes returned memory
pages clean? Thank you in advance.

[1] http://code.ohloh.net/file?fid=RPa2fuiQ5j_IwR1nymptYBBC3X4&cid=w6qrXNDsMqk

--
With best regards / с наилучшими пожеланиями,
Alexei Fedotov / Алексей Федотов,
http://dataved.ru/
+7 916 562 8095

[1] Start using Apache Openmeetings today, http://openmeetings.apache.org/
[2] Join Alexei Fedotov @linkedin, http://ru.linkedin.com/in/dataved/
[3] Join Alexei Fedotov @facebook, http://www.facebook.com/openmeetings
