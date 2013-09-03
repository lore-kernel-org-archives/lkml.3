Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3ICMFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:05:11 -0400
Received: from relay.parallels.com ([195.214.232.42]:49902 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3ICMFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:05:09 -0400
Message-ID: <5225D072.6070300@parallels.com>
Date: Tue, 3 Sep 2013 16:05:06 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: CRIU <criu@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: [Announce] Checkpoint-restore tool v0.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all!

The checkpoint-restore tool v0.7 release is ready and out,
  the changelog is at  http://criu.org/Download/criu/0.7
  the sources are at   http://download.openvz.org/criu/criu-0.7.tar.bz2

The main news about the release is that the ptrace extension to get/set sigmask
on processes and the memory changes tracker (a.k.a. soft-dirty thing) are merged
into Linux-3.11. With this done, we finally have everything, that is really
critical for C/R, and thus the project is no longer *that* kernel-dependent.

That said, from now on we shall concentrate on improving the tool performance and
stability, rather than adorning the kernel :) Also, we no longer have to keep the
CRIU releases in sync with the kernel releases, so the next one we be done as
soon as it's ready, not when the Linux-3.12 is out.

Thanks everyone who helped with the v0.7, especially with the soft-dirty stuff!

Have fun!
