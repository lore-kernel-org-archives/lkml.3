Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3JJK15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:27:57 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:55879 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3JJK14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:27:56 -0400
MIME-Version: 1.0
Date: Thu, 10 Oct 2013 11:27:55 +0100
Message-ID: <CAD4oJkM3f-CSJr9KxyQQeo_JYymnvXZD01O+-9nfuD1EaMjfLQ@mail.gmail.com>
Subject: question about get_user_pages and swapping
From: Tomasz Kantecki <tkanteck@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gup increments page->count (FOLL_GET) provided pages argument is not null.

To my limited knowledge elevated page count doesn't prevent page from
being moved from active to inactive list. What is more, such page may
also be selected for reclamaition.
Is my limited knowledge correct here?
Is there anything that would stop such page from being swapped?

Thanks,
Tomasz
