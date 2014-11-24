Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaKXAPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 19:15:47 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:59243 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaKXAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 19:15:46 -0500
MIME-Version: 1.0
Date: Mon, 24 Nov 2014 05:45:44 +0530
Message-ID: <CAHNdDV-8_uV8PPjyeO+McYcUjnW88SbT7DwB0d7WyRCJyJEk-w@mail.gmail.com>
Subject: systemctl equivalent of /sys/block/sda/device/state
From: Chaitanya Gotkhindikar <cg011235@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Not sure if this is right place to ask this doubt.

I am trying to port my old script to centos7, in which earlier device
state was set using
echo "offline" >  /sys/block/sda/device/state.

I am looking for systemctl equivalent for it. Can anyone please help?

Thank you.

-Chaitanya
