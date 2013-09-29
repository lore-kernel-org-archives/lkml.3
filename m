Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3I2KJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 06:09:06 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:45922 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3I2KJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 06:09:02 -0400
MIME-Version: 1.0
Date: Sun, 29 Sep 2013 15:39:01 +0530
Message-ID: <CAPUj1OOQf347e1Ou1FKoivHAcMdrW9SjrrwBooGd0spyjepWtA@mail.gmail.com>
Subject: AMP linux and GPU/HDMI controller sharing
From: Mj Embd <mj.embd@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have got a client request to support on their board 2 instances of
linux(Ubuntu) running as an AMP.
The board has 2 ARM cores and a GPU. The LED monitor which connects to
the board is using HDMI.

Two cores can communicate via a IPI handshake.
So release and acquire of the GPU can be done cooperatively.

My problem is that, I have done partitioning of other resources but
not sure how to share the GPU. What I have to do is save the buffers
associated with current GPU owner in memory and restore later. I dont
know much about GPU programming and am looking for pointers /any help
which is possible.

Also the solution I have to create has to be GPU agnostic.

Please help me out.
