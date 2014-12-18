Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaLRVHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:07:48 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61234 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaLRVHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:07:47 -0500
MIME-Version: 1.0
Reply-To: rogelio.serrano@gmail.com
Date: Thu, 18 Dec 2014 21:07:46 +0000
Message-ID: <CAB_-8bLk-HVWB6Mmt=rjDguou1kbGQ9c7o5nQxV3zAg+Txf7GQ@mail.gmail.com>
Subject: atomic_inc and spin_lock_irq
From: "Rogelio M. Serrano Jr." <rogelios664@gmail.com>
To: linux-kernel@vger.kernel.org, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

whats the difference between:

atomic_inc(&port->count);

and

spin_lock_irq(&port->lock);
++port->count;
spin_unlock_irq(&port->lock);
