Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964947Ab3DPO1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:27:32 -0400
Received: from mail-a03.ithnet.com ([217.64.83.98]:51822 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933715Ab3DPO1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:27:31 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Apr 2013 10:27:31 EDT
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Tue, 16 Apr 2013 16:20:47 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: No serial since kernel 3.8
Message-Id: <20130416162047.2f9b83fe.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

can some kind soul please explain how I can get my serial port back under
kernel 3.8.X. Earlier kernels showed:

Jan 10 13:57:18 mybox kernel: [    0.712829] serial8250: ttyS0 at I/O 0x3f8
(irq = 4) is a 16550A

But 3.8.4:

Mar 26 10:39:14 admin kernel: [    0.603647] serial 00:0a: disabled

Only kernel is replaced, no change in distro
Is there some kernel boot parameter needed now?
I tried 3.4.X and it works, even 3.7.X works...

-- 
Regards,
Stephan
