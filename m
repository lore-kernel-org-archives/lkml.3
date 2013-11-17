Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3KQJmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 04:42:18 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33024 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3KQJmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 04:42:08 -0500
Message-ID: <52888F6D.6000802@gmail.com>
Date: Sun, 17 Nov 2013 10:42:05 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I recently acquiered a new laptop. After installing archlinux which is
shipping a kernel 3.12, I've got some troubles after resuming from each
suspend to RAM.

The behaviour is as following: each resumes correctly and my session
seems to be restored but after typing a command on the term, I got a
black screen and the fan is becoming noisy which seems to indicate the
cpus are running intensively.

Today I got a different behaviour, after resuming I got a kernel panic.
I could take a picture of the laptop screen: http://imgur.com/f5uWFTY

Could anybody help me to sort this out ?

Thanks.
