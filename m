Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaADNTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 08:19:21 -0500
Received: from smtp03.stone-is.org ([87.238.162.66]:43275 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaADNTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 08:19:18 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <52C80A50.3000602@acm.org>
Date: Sat, 04 Jan 2014 14:19:12 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <greg@kroah.com>
CC: Ming Lei <ming.lei@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [0/3] Driver core patches for kernel 3.14
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series consists of the following three patches:
0001-kobject-Fix-source-code-comment-spelling.patch
0002-firmware-loader-Add-sparse-annotation.patch
0003-driver-core-Fix-use-after-free-triggered-by-bus_unre.patch

