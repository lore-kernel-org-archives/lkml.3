Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaF1Ggd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 02:36:33 -0400
Received: from forward5m.mail.yandex.net ([37.140.138.5]:36744 "EHLO
	forward5m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaF1Ggc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 02:36:32 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2014 02:36:32 EDT
From: Fouldmother Finnishfucker <super.fmff@yandex.com>
Envelope-From: super-fmff@yandex.com
To: LKML <linux-kernel@vger.kernel.org>
Subject: Problems booting kernel with UEFI bios 
MIME-Version: 1.0
Message-Id: <7992981403937083@web26m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 28 Jun 2014 02:31:23 -0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings

Two years ago I decided to ditch the shim and shams that come with booting in UEFI on the laptop. This was working fine. The last year someone had a suggestion to sign the kernel, and enable certificate checking, as describe here http://kroah.com/log/blog/2013/09/02/booting-a-self-signed-linux-kernel/, and this too was good.

Then along came version 3.15.0. The same config but now I see an EFI_MIXED option. I tried ignoring this, and I found that I could not boot. I enabled this and I still get the same result. So I waited for two versions to see if the problem is fixed and nothing. I have tried using early printks in EFI and the display is blank. I have no serial, but USB and I cannot get the traces out. So two questions: Has anyone else the same woes? and more importantly how does one debug this stuff? I tried qemu with tianocore and that barfs on the 3.14.8 kernel that is currently working.

Any suggestions would be apprecaited.

FM FF
