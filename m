Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3DXKHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:07:03 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:64918 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3DXKHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:07:00 -0400
MIME-Version: 1.0
From: Bian LuLu <helianthus.lu@gmail.com>
Date: Wed, 24 Apr 2013 18:06:39 +0800
Message-ID: <CAG82n_ni9ZAThGbMfqqObnz7QyQpH18G4hYBLt+BdeRHPE6EBg@mail.gmail.com>
Subject: [RFC] The meaning of local_cpulist and local_cpus
To: linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Recently, i read some codes of PCI portions. I think
local_cpulist is a list about one kind of CPU and
local_cpus is a mask of CPU. But i am not sure when
and how i should use these two parameters.

See http://lxr.linux.no/linux+v3.5.4/drivers/pci/pci-sysfs.c#L390 for
details.

Would anyone please give me some suggestions?
Thanks in advance ;-)


Thanks
Lulu Bian
