Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaFPCrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 22:47:51 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:36458 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaFPCrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 22:47:47 -0400
MIME-Version: 1.0
Date: Sun, 15 Jun 2014 22:47:46 -0400
Message-ID: <CAPDOMVh48+gQ-p22QAFjaM5ALMLVak1rQq99GtCfhgjwmFWf4w@mail.gmail.com>
Subject: Bug ID 44611 Seems Fixed
From: Nick Krause <xerofoify@gmail.com>
To: nhorman@tuxdriver.com, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Netdev Team,
This bug seems,  fixed https://bugzilla.kernel.org/show_bug.cgi?id=44611.
I seem to believe this bug is fixed after I checked the related file.

    if (skb) { seems to fix the not checked for NULL in the related function.
I would close this bug unless there are other issues with it.
Cheers Nick
