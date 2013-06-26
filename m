Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3FZKe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:34:56 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:54241 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3FZKez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:34:55 -0400
MIME-Version: 1.0
Date: Wed, 26 Jun 2013 18:34:54 +0800
Message-ID: <CAFiDJ5-0wtYAG3HdxSQsjajUuu34LEu2NvTD3eRDRVTDF=s_cA@mail.gmail.com>
Subject: Hardware mutex common framework
From: "LF.Tan" <lftan.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Do we have hardware mutex common framework available in kernel? I
can't find in drivers/, but, I found there is a hardware spinlock
framework under drivers/hwspinlock.

I believe the spinlock and mutex should have different framework.
Please correct me if wrong.

I would like to introduce a hardware mutex common framework in kernel
if it is not exist yet. What is the procedure for this? Or I can just
directly submit the patch to kernel mailing list?

Thanks.
