Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaCXNgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:36:07 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:46891 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaCXNgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:36:06 -0400
From: Mikael Pettersson <mikpelinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21296.13504.469935.427413@gargle.gargle.HOWL>
Date: Mon, 24 Mar 2014 14:36:00 +0100
To: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Q: uniqueness of pthread_t
In-Reply-To: <533019C9020000A100014F79@gwsmtp1.uni-regensburg.de>
References: <533019C9020000A100014F79@gwsmtp1.uni-regensburg.de>
X-Mailer: VM 8.1.2 under 24.1.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Windl writes:
 > Hi!
 > 
 > I'm programming a little bit with pthreads in Linux. As I understand pthread_t is an opaque type (a pointer address?) that cannot be mapped to the kernel's TID easily. Anyway: Is it expected that when one thread terminates and another thread is created (in fact the same thread again), that the p_thread my be resused?

Wrong list, please try <libc-help@sourceware.org> instead.
