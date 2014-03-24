Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaCXNYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:24:54 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:42312 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaCXNYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:24:52 -0400
Date: Mon, 24 Mar 2014 13:24:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, angus.clark@st.com,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org, kernel@stlinux.com
Subject: New NAND driver
Message-ID: <20140324132446.GA21665@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

Firstly I'd like to thank you for supporting the inclusion of ST's SPI
NOR (FSM) driver. As promised I will convert it over to the new
framework once it has been applied by your good self.

In the meantime however, I have a NAND driver which I need to
submit. I wanted to give you a heads-up prior to sending it in case
you had any special requests. FYI: Shoving it where the sun don't
shine, is not a valid request by the way :). It's 2700 lines and I've
split it over 47 patches for reviewing purposes.

Sorry to do this to you Brian, I am sensitive to how over-burdened you
are with the subsystem already. Perhaps it might make sense to put out
a plea for volunteers to help with maintain MTD subsystem on LKML?

Anyway, what's the best thing to do in this instance? Should I just
send it to the list as an RFC and be done with it?

Kind regards,
Lee

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
