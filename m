Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3AROq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:46:57 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58043 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3AROq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:46:56 -0500
MIME-Version: 1.0
Date: Fri, 18 Jan 2013 15:46:53 +0100
Message-ID: <CAHTX3dJ2Qqs6QxJEcd24KW5y2DSumLy82jvVUxBjjMWQULrxdQ@mail.gmail.com>
Subject: request_mem_region() for noPCI devices
From: Michal Simek <monstr@monstr.eu>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

just want to check with you usage of request_mem_region for noPCI devices.
kernel/resource.c suggests that it should be used just for PCI iomem
(iomem_resource uses name PCI mem).

If I grep architectures I see several usage for noPCI devices.

Does it mean that request_mem_region should be used for all devices
which request io memory? Or just for PCI iomem?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian
