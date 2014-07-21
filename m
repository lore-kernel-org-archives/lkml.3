Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaGUXZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:25:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaGUXZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:25:43 -0400
Date: Mon, 21 Jul 2014 16:25:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stuart Longland <stuartl@vrt.com.au>
Cc: Roman Fietze <roman.fietze@telemotive.de>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] drivers/rtc/rtc-isl12022.c: Device tree support
Message-Id: <20140721162542.bad28d41502f7a2c57695412@linux-foundation.org>
In-Reply-To: <1405477705-16885-2-git-send-email-stuartl@vrt.com.au>
References: <1405477705-16885-1-git-send-email-stuartl@vrt.com.au>
	<1405477705-16885-2-git-send-email-stuartl@vrt.com.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014 12:28:25 +1000 Stuart Longland <stuartl@vrt.com.au> wrote:

> Add some support for configuring isl12020/isl12022 devices using the
> Device Tree blob.

checkpatch said

WARNING: DT compatible string "isl,isl12022" appears un-documented -- check ./Documentation/devicetree/bindings/
#50: FILE: drivers/rtc/rtc-isl12022.c:278:
+       { .compatible = "isl,isl12022" },
