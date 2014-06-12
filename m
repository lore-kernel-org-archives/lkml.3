Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbaFLKHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:07:42 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60321 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFLKHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:07:41 -0400
MIME-Version: 1.0
Date: Thu, 12 Jun 2014 11:07:40 +0100
Message-ID: <CADjbhK4G0Jp+x-gZ7DmKx2Uz2i+zD53NzvmnwUuZjK3YERSAqA@mail.gmail.com>
Subject: [mac80211] send ethernet packet
From: Bruno Correia <bcorreia.c@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am trying to send a custom ethernet packet through a kernel module
(mac80211) and I am facing some problems to understand what I really
need to do.

Until now, I realize that I need to create an "sk_buff" and send it
via "dev_queue_xmit" function. Am I right?

My problem is how to properly create and fill all the needed fields of
"sk_buff" with my data (I only need to pass a number).

In order to give you some context, I am working on a research in IEEE
802.11 and I am developing a mechanism to send the packets in an
energy efficient way. Therefore, I need to employ a specific algorithm
before adding the "Traffic Indication Map" (TIM) into the "Beacon"
frame and, depending on the results of this algorithm, I need to send
an extra message to the station. This is why I cannot simply use a raw
socket in the user space, for example.

Any idea how to achieve my goal? Or any point to a "guide" that help
me to understand what I really need to do?

The kernel version in use is the "3.2.0-4-686-pae".

Best regards,
Coiso22

ps.: I wish to be personally CC'ed the answers/comments posted to the
list in response to my post.
