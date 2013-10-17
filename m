Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3JQNOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:14:49 -0400
Received: from mail-qe0-f47.google.com ([209.85.128.47]:41640 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3JQNOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:14:47 -0400
MIME-Version: 1.0
Date: Thu, 17 Oct 2013 18:44:45 +0530
Message-ID: <CAJ_BOiC3gSUKwQg8maayg0S7tdcY6ME86QBYWpiGwXk7mBSL_Q@mail.gmail.com>
Subject: x86 like DEBUG_PAGEALLOC for ARM
From: Prabhat Kumar Ravi <prabhatravi09@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As in our present ARM kernel we don't have feature like
DEBUG_PAGEALLOC which generate exception if a program touched the
unmaped pages.

Trying to implement kernel_map_pages() for ARM,

Can anyone help me in that.


Regards,
Prabhat
