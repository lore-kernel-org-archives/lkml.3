Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3GOGSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:18:04 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59843 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab3GOGSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:18:01 -0400
MIME-Version: 1.0
Date: Mon, 15 Jul 2013 11:48:00 +0530
Message-ID: <CAK7N6vokZpFJkYapajhqTYWvPVWr6ELz+5Nq9yvf0J5VAx=JBA@mail.gmail.com>
Subject: Question:Bsearch replace the search_extable implementations
From: anish singh <anish198519851985@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
        Tim Abbott <tabbott@ksplice.com>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rusty,

Right now I see so many places in the kernel
where we open code binary search implementations
such as search_extable implementations.

http://lxr.free-electrons.com/ident?a=powerpc;i=search_extable

Would it be ok to replace this with bsearch lib code?

I am not trying to fix any problem nor I see
any problem in current implementations but
if we can replace the large amount of code
would it not be a good reason to send a patch
for this?

anish
