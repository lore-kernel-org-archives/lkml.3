Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab3GQJEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:04:13 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39836 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3GQJEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:04:11 -0400
MIME-Version: 1.0
In-Reply-To: <1372949115-8190-1-git-send-email-jonas.jensen@gmail.com>
References: <1371040448-28742-3-git-send-email-jonas.jensen@gmail.com>
	<1372949115-8190-1-git-send-email-jonas.jensen@gmail.com>
Date: Wed, 17 Jul 2013 11:04:10 +0200
Message-ID: <CACmBeS0LHqm8=4hM4VaDCBZZEP9-er7rP+SfJ7GnpgiGvJm+2Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ARM: mach-moxart: add MOXA ART device tree files
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org, arnd@arndb.de,
        olof@lixom.net, Jonas Jensen <jonas.jensen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as a reminder, I intend to update this set with some minor changes:

1. remove devicetree bindings for drivers, I will mail those out separately
2. a devicetree node for DMA was added
3. GPIO numbers are now in DT aswell

Best regards,
Jonas
