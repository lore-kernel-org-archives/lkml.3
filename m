Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaFIFES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 01:04:18 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:32777 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaFIFEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 01:04:16 -0400
Date: Mon, 09 Jun 2014 14:04:12 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: [Question] Why CONFIG_SHELL
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140609140411.95B6.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts.

I think all the macros with CONFIG_ prefix are supposed to be
defined in Kconfig.
But I've been long wondering why there exists one exception:
CONFIG_SHELL.

Is there any historical, or special reason?

Is it good to rename it to KBUILD_SHELL or something else?


Best Regards
Masahiro Yamada

