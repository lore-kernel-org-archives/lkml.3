Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbbAKNp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:45:57 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:57950 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbbAKNpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:45:55 -0500
MIME-Version: 1.0
Date: Sun, 11 Jan 2015 15:45:54 +0200
Message-ID: <CAC9RQtjMb9uarH9w59Fp+LJ=5s6cmRfgids5TGt4SJg25OMoYA@mail.gmail.com>
Subject: Transaction File implementation question
From: Greg Young <gregoryyoung1@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Been reading through tons of old threads about varying transaction
file implementations. As many of the discussions are old (some over a
decade) what is considered the best way of implementing today? It
appears that o_direct is frowned upon, is the current preferred
mechanism to use mmap and basically append pages + partial sync when
writing (one issue with the second is that it doesn't work in say
windows where as o_direct does)?

We currently follow the added constraints mentioned by Linus in an old
email (lost link) in that we use o_direct but prealloc and only use
o_direct when reading. Is it worth looking at a mmap implementation?

Thanks in advance,

Greg

-- 
Studying for the Turing test
