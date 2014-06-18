Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaFRU2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:28:21 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38078 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaFRU2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:28:20 -0400
Message-ID: <53A1F65C.9090907@gmail.com>
Date: Wed, 18 Jun 2014 22:28:12 +0200
From: Sorin Manolache <sorinm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Icedove/30.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: drivers/acpi/ac.c, re-enabling CONFIG_ACPI_PROCFS_POWER?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Would it be worth considering re-enabling the old procfs interface for 
ac.c? There are old tools still around (kpowersave from kde 3.5.10) that 
expect /proc/acpi/ac_adapter.

Thank you,
Sorin
