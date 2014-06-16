Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaFPJ52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:57:28 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:50996 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaFPJ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:57:26 -0400
MIME-Version: 1.0
Date: Mon, 16 Jun 2014 15:27:26 +0530
Message-ID: <CAD6G_RRa9C0umBrR6CUF3zb5cSKKfZO7y7UPUKHjJOx41A0aJQ@mail.gmail.com>
Subject: I2C Slave monitor mode support
From: Jagan Teki <jagannadh.teki@gmail.com>
To: linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Few of the I2C interfaces are [operated] with slave monitor mode, when
there is a requirement for
a particular slave may need to wait some time to get the ADDR before
sending an ACK.

In slave monitor mode, the I2C interface is set up as a master and
continues to attempt a transfer to
a particular slave until the slave device responds with an ACK.

This feature is an optional and defined in few of the controllers, Can
anyone tell me is this support is
added already in kernel, if yes please point to the respective driver
or code link.

thanks!
-- 
Jagan.
