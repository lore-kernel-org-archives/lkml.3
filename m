Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaLZJiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:38:14 -0500
Received: from mail-vc0-f196.google.com ([209.85.220.196]:52752 "EHLO
	mail-vc0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLZJiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:38:11 -0500
MIME-Version: 1.0
Date: Fri, 26 Dec 2014 17:38:10 +0800
Message-ID: <CAFE0N_hXqQ_SdFumcYGC6_VajMxXM=j1UOHWkj-0GueXGFndbA@mail.gmail.com>
Subject: how to replace an existing I2C driver with my driver?
From: Nick Yao <nickyaolinuxkernel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts,


The existing driver has compatibility issues with my devices, and
there're other devices depend on the old driver.
I want to replace the existing I2C driver with my own driver while not
affect the other I2C devices.
How can I do it?

Thanks.

BRs.



Nick Yao
