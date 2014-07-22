Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaGVGKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:10:40 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:47746 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaGVGKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:10:39 -0400
MIME-Version: 1.0
Date: Tue, 22 Jul 2014 02:10:38 -0400
Message-ID: <CAPDOMVg1Tket3eMcuDZhmP=h5L3BRxYrGByYjAzgHzuprLJ9ww@mail.gmail.com>
Subject: intel-gtt.c:fix me
From: Nick Krause <xerofoify@gmail.com>
To: airlied@linux.ie
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 #if IS_ENABLED(CONFIG_AGP_INTEL)
 652         global_cache_flush();   /* FIXME: ? */
 653 #endif

I am wondering what to do about this fix me?
Cheers Nick
