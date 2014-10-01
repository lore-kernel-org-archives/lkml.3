Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaJAO72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:59:28 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:43455 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaJAO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:59:27 -0400
Message-ID: <542C1765.7010501@gmail.com>
Date: Wed, 01 Oct 2014 17:01:57 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Why is max_part default value  0 for loop devices ?
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm wondering why max_part parameter for loop device is 0 by default.

Also would it make sense to allow one to change this default value at
kernel build time ?

Thanks.
