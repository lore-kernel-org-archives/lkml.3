Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbaGCRVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:21:39 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:38921 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaGCRVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:21:36 -0400
MIME-Version: 1.0
Date: Thu, 3 Jul 2014 13:21:35 -0400
Message-ID: <CAPDOMVj3sJSfgA7hBv9Tx0oz5ZX73robsTZygVJfU_QZ9A65dg@mail.gmail.com>
Subject: FIX ME message in osf_sys.c
From: Nick Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, Matt Turner <mattst88@gmail.com>,
        linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be a Fix Me message on line 892 due to info.si_addr = NULL.
I am wondering what value I should declare this variable to instead of Null.
Cheers Nick
