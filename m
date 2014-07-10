Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaGJSsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:48:13 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:39833 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaGJSsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:48:12 -0400
MIME-Version: 1.0
Date: Thu, 10 Jul 2014 14:48:11 -0400
Message-ID: <CAPDOMVjkcZ9At-=Saqktm3dCTGH-FxoGZmq+SC9fjae44rDFVw@mail.gmail.com>
Subject: Unwind.c fix mes
From: Nick Krause <xerofoify@gmail.com>
To: vgupta@synopsys.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Vinnet,
I seem to hitting with cscope  fixes in unwind.c  in this function,
__init setup_unwind_table.
Since you are the maintainer of this file I am wondering how to want
to handle these null
pointers.
Cheers Nick
