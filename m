Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3J2O55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:57:57 -0400
Received: from mout.gmx.net ([212.227.15.15]:52009 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab3J2O54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:57:56 -0400
MIME-Version: 1.0
Message-ID: <trinity-f65147f9-012f-4e78-a5a6-3f969ff5b9bf-1383058674646@3capp-gmx-bs07>
From: "John Twideldum" <twideldums_throwaway@gmx.at>
To: linux-kernel@vger.kernel.org
Subject: Aw: 3.12-rc5 and overwritten partition table - by powertop?
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Oct 2013 15:57:54 +0100 (CET)
Importance: normal
Sensitivity: Normal
In-Reply-To: <trinity-ee0bd2b5-ce28-4895-8c2a-2f60f40e49f4-1383046621263@3capp-gmx-bs07>
References: <trinity-ee0bd2b5-ce28-4895-8c2a-2f60f40e49f4-1383046621263@3capp-gmx-bs07>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:az+fpqeLy1Ae0GvA0x4lt2cU2JXjUDMxAvb/AF8e48v
 iVLMdl8tlntgTanBpM/C5/g9V42NJp3X1stEib4yWizm4ZJEUC
 /PEfQINox9yCvJQdbck5dXtnKM6PzCxQOwlEoOiaHQ+7g7I4OW
 6vSrxmDIo5f+u+MtPtlnJNjyr3PWHSgGcuFsb6cn3qY0Crkm/l
 w11baNppoVcl3lrhRPAkc5thn/7W7W2KlnitJO4LdirRkAgnbZ
 h9m9gPEfWONWthaRsLBA/+SK8Me/UxytMZIIIU3O+WrZIf6cn+ Hbw3TY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replying to myself with more insights...
 
>0000000 13.00000\nalsa:hw
>0000020 C0D0\t99.00000\nal
>0000040 sa:hwC0D3\t99.000
>0000060 00\nbacklight:acp
>.....

The first ~170kb of /dev/sda got blown away with what seems to be a logging output
by Powertop, when I was playing with the tuneables.
(Luckily the first partition starts later :-))

Why is that I don't know, but maybe when turning on the SATA knobs
something goes wrong. I'm afraid to try again, but I accept rather higher
power use than data loss again :-/

Sorry for the confusion...
J
