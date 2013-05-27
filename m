Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3E0NLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:11:37 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36165 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab3E0NLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:11:36 -0400
MIME-Version: 1.0
Date: Mon, 27 May 2013 18:41:35 +0530
Message-ID: <CANMsd00MEep_+aSfQ7s9ksL=XmzwNtVALN1h0uZzSEQSM_u2FQ@mail.gmail.com>
Subject: Affine issues
From: Ryan <ryanphilips19@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do we get the message:

IRQ79 no longer affine to CPU1


Is this a hard error? As i understand this comes during CPU hotplug.

Can anyone explain when this happens. I am not interrester in IRQ79,
But more interested in why this occurs?


Thanks,
Ryan
