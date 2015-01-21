Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbbAUQm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:42:26 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:33184 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbbAUQmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:42:21 -0500
MIME-Version: 1.0
Reply-To: whiteheadm@acm.org
Date: Wed, 21 Jan 2015 11:42:20 -0500
Message-ID: <CAP8WD_bOtMwitQ5QOotC2onRYm5J1H3xXRPvJC_2V9r04pD3iA@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: drop support for 1995 era EISA based platforms
From: tedheadster <tedheadster@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I too have old EISA systems that I am using with current kernels.
They're good for testing, having uncovered a kernel bug previously
with Thomas Gleixner:

https://lkml.org/lkml/2013/11/13/424

- Matthew
