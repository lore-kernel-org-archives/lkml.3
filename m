Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab3GHIGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:06:20 -0400
Received: from callisto.mysnip.de ([178.23.121.164]:58594 "EHLO
	callisto.mysnip.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3GHIGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:06:18 -0400
To: linux-kernel@vger.kernel.org
Subject: Bluez with uclibc
X-PHP-Originating-Script: 1000:email_functions.php
Content-Type: text/plain; charset=UTF-8
X-Mailer: Phorum5
Message-ID: <6e9104c416ff417b9c63f47891f947ea.LinuxKernel@www.serverphorums.com>
X-Phorum: 1a38330efb91e5f9021ae2fc13b39ae0412706f1
From: lkml@serverphorums.com
Date: Mon,  8 Jul 2013 10:06:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6886QE5003630

Hi,

Today, I need to cross compile Bluez for arm with uclibc library into Buildroot environment. 
However, I meet some dependencies between bluez-utils package and MMU deactivation due to dBus.

Do you know a way to use Bluez with uclibc library?

Thanks in advance

Regards

---
posted at http://www.serverphorums.com
http://www.serverphorums.com/read.php?12,739510,739510#msg-739510
