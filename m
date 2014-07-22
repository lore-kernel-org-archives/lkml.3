Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaGVGRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:17:46 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:34351 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaGVGRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:17:45 -0400
MIME-Version: 1.0
Date: Tue, 22 Jul 2014 02:17:44 -0400
Message-ID: <CAPDOMVikKnHvK-O+20dL1apM=Hi6bDqxn8uVcrhHtsE1sufRUw@mail.gmail.com>
Subject: drbd_worker.c: Remove lines
From: Nick Krause <xerofoify@gmail.com>
To: drbd-dev@lists.linbit.com
Cc: drbd-user@lists.linbit.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be two fix mes in function in wait_for_work. I was
wondering can we remove these spinlocks?
Cheers Nick
