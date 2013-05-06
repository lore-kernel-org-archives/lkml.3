Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3EFKzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:55:53 -0400
Received: from mail-a02.ithnet.com ([217.64.83.97]:36674 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753058Ab3EFKzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:55:52 -0400
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Mon, 6 May 2013 12:55:48 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: virtio-net in 3.9 and below
Message-Id: <20130506125548.8a482bdc.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

during heavy testing I found out that kernel 3.9 virtio-net seems to have a
lot better performance than former kernel versions.
I am not quite sure if this is due to general enhancements in 3.9 or specific
to the virtio-net code.
In case someone thinks its really virtio-net, is there a chance to backport
this code to 3.4.X or even 3.2.X ? Some older boxes just don't compile 3.9, so
this could be quite helpful.
Please cc me in case of answer.

-- 
Regards,
Stephan
