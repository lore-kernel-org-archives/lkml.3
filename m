Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaFLGyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:54:17 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52451 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaFLGyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:54:15 -0400
Message-ID: <53994E93.2030606@gmail.com>
Date: Thu, 12 Jun 2014 08:54:11 +0200
From: Branimir Maksimovic <branimir.maksimovic@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: btrf stuck in iowait with latest git
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last night I have pulled and installed latest kernel and immediateley
noticed that git pull on btrfs file system is stuck.
Io wait was high without noticing that there is something
to wait for. Also noticed that btrfs_transactio process was
stuck with 'D'. Tryed sync and that also got stuck.
I think that this is easilly reproducable and noticable.

Branimir.

