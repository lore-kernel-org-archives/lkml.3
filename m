Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbaCRVNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:13:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59027 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888AbaCRVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:13:10 -0400
From: Silvio F <silvio.fricke@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: daeseok.youn@gmail.com, silvio.fricke@gmail.com, silvio@port1024.net,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org
Subject: [patch][wip] staging: unisys: kmalloc/memset move to kzalloc
Date: Tue, 18 Mar 2014 22:13:09 +0100
Message-Id: <1395177190-19806-1-git-send-email-silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have followed this thread and have seen that not all parts was kcalloc'ized.
Please review this patch and maybe include it.

This patch is WIP because I have  no hardware and can only do a compile test.

version 2:
* remove ALLOC_CMDRSP define


Bye,
Silvio

