Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3CNEi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:38:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:33820 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3CNEi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:38:27 -0400
X-Spam-Score: -100.8
Message-ID: <51415428.1070401@asianux.com>
Date: Thu, 14 Mar 2013 12:38:00 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, nico@linaro.org,
        matthew.leach@arm.com, dave.martin@linaro.org
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] Latest randconfig build errors for Head.S
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

  are these warnings for head.S OK ?


make:
  make V=1 EXTRA_CFLAGS=-W ARCH=arm randconfig
    (this time, CONFIG_MMU=y)

warning information:
  arch/arm/boot/compressed/head.S: Assembler messages:
  arch/arm/boot/compressed/head.S:565: Warning: (null)
  arch/arm/boot/compressed/head.S:676: Warning: (null)
  arch/arm/boot/compressed/head.S:698: Warning: (null)
  arch/arm/boot/compressed/head.S:722: Warning: (null)
  arch/arm/boot/compressed/head.S:726: Warning: (null)
  arch/arm/boot/compressed/head.S:735: Warning: (null)
  arch/arm/boot/compressed/head.S:978: Warning: (null)
  arch/arm/boot/compressed/head.S:1017: Warning: (null)
  arch/arm/boot/compressed/head.S:1018: Warning: (null)
  arch/arm/boot/compressed/head.S:1048: Warning: (null)
  arch/arm/boot/compressed/head.S:1055: Warning: (null)
  arch/arm/boot/compressed/head.S:1063: Warning: (null)
  arch/arm/boot/compressed/head.S:1074: Warning: (null)
  arch/arm/boot/compressed/head.S:1088: Warning: (null)
  arch/arm/boot/compressed/head.S:1120: Warning: (null)
  arch/arm/boot/compressed/head.S:1122: Warning: (null)
  arch/arm/boot/compressed/head.S:1123: Warning: (null)
  arch/arm/boot/compressed/head.S:1130: Warning: (null)
  arch/arm/boot/compressed/head.S:1162: Warning: (null)



-- 
Chen Gang

Asianux Corporation
