Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934993Ab3E2CLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:11:00 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44923 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934963Ab3E2CK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:10:59 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: [PATCH 0/3] Try out the irqdomain + generic chip integration series
Date: Wed, 29 May 2013 03:10:51 +0100
Message-Id: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Rather than just straight reviewing the generic irq chip patch series, I
tried it out by converting another driver to use it. As far as I've been
able to tell it does the right thing and you can have my ack. The first
patch in this series adds another feature needed by the versatile
driver. Patch 2 should be okay, but I'd like to get an ack from Ben
before it gets applied.

I need to get someone to test patch 3 on hardware before you pick up
that one.

Oh, and I'll reply directly to patch 7 of your series with an ack and a
minor comment.

Cheers,
g.

