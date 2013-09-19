Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3ISBNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 21:13:54 -0400
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:59052 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889Ab3ISBNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 21:13:53 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2013 21:13:53 EDT
Message-ID: <1379552845.4788.6.camel@mjolnir.site>
Subject: unsupported usb bluetooth device
From: "Ken O'Brien" <kernel@kenobrien.org>
To: marcel@holtmann.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 19 Sep 2013 02:07:25 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've acquired a Belkin "Mini Bluetooth v4.0 Adapter" F8T065bf
8830bf12557 Rev. A01.

I'm running Linux 3.7.10-1.16 (openSUSE 12.3) and this device is not
detecting beyond what I can see in lsusb.

What steps can I take to aid in patching the kernel to support this
device? I am a proficient C/asm programmer but I've not done kernel
driver dev before.

Best Regards,

Ken


