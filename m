Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964903Ab3BTQUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:20:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57677 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935408Ab3BTQUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:20:17 -0500
Message-ID: <5124F7BA.5080905@steinhoff.de>
Date: Wed, 20 Feb 2013 17:20:10 +0100
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: io_apic.c   -->  "nr_ioapics" not initialized !
References: <20130219035623.277664914@goodmis.org> <20130219035646.405150342@goodmis.org>
In-Reply-To: <20130219035646.405150342@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:GC7Z452lnWR3t9u4W0EyohrKdWtbA79hBZor0WrV6tM
 GemWH3yH+O33BHXkcC5mFxYydapFljLrjATrJTx5JOuynSUuPC
 N3Wtwql/urECqHbZ2l6saWzzHBzgOjNItab7v0ZdCCFeHEcYvO
 6OQ9tCBUaG8C0Moja/bwgTQdRrrTOi5BCqBJZOirUQz1dto7fg
 do0pfbEWkbm6MQBTWKuGcSGLNe7Xnq/SGqGQgSfJrwq26Wg0Wu
 bXVbpfG/2QoF3UfTbvHHi3ReanyT6ZPo3854K6Ct9ZdfE7UT2G
 pAOcUvQQeJY2vCU6OwkV1zHjSPM7cn0v3j5LPeER+wMuMHarZp
 /+Yy9uMt3xO8nmPdGw0c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

after a walk through the module "io_apic.c" in 
"/usr/src/linux/arch/x86/kernel/apic" I got the impression that the 
variable "nr_ioapics" is used but isn't initialized !
Could it be the source of boot problems ?

Dangerous coding stile in "static struct resource * __init 
ioapic_setup_resources(int nr_ioapics)" ....
########

Cheers

--Armin


