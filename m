Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaGDIZC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:25:02 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:50443 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaGDIY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:24:59 -0400
MIME-Version: 1.0
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Fri, 4 Jul 2014 10:24:43 +0200
Message-ID: <CAL8zT=jVVJ7WB7PtXwbKji5efoZHxWVwD4LgVsuXc3gsW+9=kw@mail.gmail.com>
Subject: Lattice ECP3 load firmware
To: Stefan Roese <sr@denx.de>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I noticed you (Stefan) are using request_firmware_nowait() call. This
means user needs to explicitly call it using

$ echo 1 > /sys/class/firmware/lattice-ecp3.0/loading
$ cat lattice-ecp3.bit > /sys/class/firmware/lattice-ecp3.0/data
$ echo 0 > /sys/class/firmware/lattice-ecp3.0/loading

Or did I miss something ?
I would like to have it load the firmware bitstream when booting if
there is a specific .bit file in /lib/firmware. Maybe don't you want
to have this behaviour, though... ?

Thanks,
JM
