Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab3ANKhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:37:08 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41214 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3ANKhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:37:07 -0500
MIME-Version: 1.0
From: Bora Erbas <bora.erbas@gmail.com>
Date: Mon, 14 Jan 2013 12:36:45 +0200
Message-ID: <CABGFC5_V1MKmN_2DyZpNo+zStEMLZ_Md1EhGP_eA-K5QzT-iug@mail.gmail.com>
Subject: kernel module not installing on debug kernel: lockdep_init_map
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We have some kernel modules that are working on Centos 5.x.
Now we are in the process of porting them to Centos 6.x.

After the initial tests we have observed some freezes with the Centos
6.x while using our modules.
So we decided to utilize the debug kernel during the porting phase.

However, the module is not installing with the error "Unknown symbol
lockdep_init_map".
I am using the below kernel:
kernel-debug-2.6.32-279.2.1.el6.x86_64.rpm

I believe this is not related with the distribution and rather with
the kernel itself, thus I am posting here.
Please correct me if I'm wrong.

Is there a workaround for this? Any pointers are appreciated.

Thanks in advance.

Regards.
