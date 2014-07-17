Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaGQEXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:23:10 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:50355 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaGQEXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:23:06 -0400
MIME-Version: 1.0
Date: Thu, 17 Jul 2014 00:23:04 -0400
Message-ID: <CAPDOMVjs1x_RFOcAvRHvtEdXaOU+vF9ovjXLVL=yqZfaG3YFoA@mail.gmail.com>
Subject: Issues with test builds
From: Nick Krause <xerofoify@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am having issues with build tests. Seems arch/x86/Makefile:136:
CONFIG_X86_X32 enabled but no binutils support
is the culprit. I am new so how do I fix this.
Cheers Nick
