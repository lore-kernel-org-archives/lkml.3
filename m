Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaAKCcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 21:32:13 -0500
Received: from forward4m.mail.yandex.net ([37.140.138.4]:40888 "EHLO
	forward4m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaAKCcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 21:32:12 -0500
From: Victor Porton <porton@narod.ru>
Envelope-From: porton@yandex.ru
To: linux-kernel@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
Subject: Impementing sandbox in Linux
MIME-Version: 1.0
Message-Id: <82261389407526@web6m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 11 Jan 2014 04:32:06 +0200
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://portonsoft.wordpress.com/2014/01/11/toward-robust-linux-sandbox/
considers some issues of implementing sandboxing in Linux.

I am unsure whether Linux supports waiting until a cgroup becomes empty (what is needed for sandboxing software). If it does not support, please make a patch.

Please post comments to the above blog post.

If you answer this message, please CC: me, I am not subscribed to this mailing list.

-- 
Victor Porton - http://portonvictor.org
