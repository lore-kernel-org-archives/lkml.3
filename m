Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab3JGLIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:08:13 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:48456 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3JGLIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:08:10 -0400
MIME-Version: 1.0
Date: Mon, 7 Oct 2013 13:08:09 +0200
Message-ID: <CAKqeN29hu55Q0qXioaZKAppK-aA68rCaDUFg2z2AvUSEnnyMDA@mail.gmail.com>
Subject: file_inode() vs f_mapping->host
From: Andre Richter <andre.o.richter@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

in this thread ( https://lkml.org/lkml/2013/3/17/128 ), Al Viro argues
that file_inode() is not equal to f_mapping->host in certain cases.

I'm asking, because in arch/x86/kernel/msr.c, msr_seek() retrieves the
inode via f_mapping while one function later, msr_read() uses
file_inode().
Is this on purpose?

In general, how do I distinguish when to use what?

Thanks in advance,
Andre
