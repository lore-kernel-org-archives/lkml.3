Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3DWMIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:08:40 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:37997 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3DWMIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:08:39 -0400
MIME-Version: 1.0
From: =?UTF-8?B?5Y2e55KQ55KQ?= <helianthus.lu@gmail.com>
Date: Tue, 23 Apr 2013 20:08:18 +0800
Message-ID: <CAG82n_mMmiZO-xF6D1kBtc8ZfPHEDbjLBp2Fnzh4y=FNJ-_zpg@mail.gmail.com>
Subject: [HELP] SYSFS:/sys/devices/pci*/.../local_cpulist, local_cpus
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,all:
      As I execute command:
'cat /sys/devices/pci*/.../local_cpulist ' ,and the result is '0-7' .
'cat /sys/devices/pci*/.../local_cpus', and the results is 'ff'.
     Can anybody tell me what's the usage of them?
