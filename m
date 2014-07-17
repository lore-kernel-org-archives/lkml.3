Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaGQCZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:25:33 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:43598 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaGQCZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:25:31 -0400
MIME-Version: 1.0
Date: Wed, 16 Jul 2014 22:25:30 -0400
Message-ID: <CAPDOMVjTxTNTfgPJMz6eNfabXuvtJ43YMpEeDEQ236EtF168Cg@mail.gmail.com>
Subject: Sparc: Fix Mes in highmem.c
From: Nick Krause <xerofoify@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am hitting three Fix mes in this file and am wondering as the
maintainer how you would like
to clean them up.
Cheers Nick
