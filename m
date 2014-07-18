Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbaGROzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:55:49 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51273 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965152AbaGROzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:55:48 -0400
MIME-Version: 1.0
Date: Fri, 18 Jul 2014 17:55:45 +0300
Message-ID: <CACVxJT9LYMA+x=KkpAZ7aONErS5zi+tWdSENiRXuDGxQv28zsA@mail.gmail.com>
Subject: Re: How to automate checkpatch && get_maintainers && git send-email
 of commits range?
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there script for automated checkpatch.pl && get_maintainers.pl &&
> git send-email for range of commits? I see none. Would it be welcome
> to submit such one to kernel tree?

Spurious checkpatch.pl changes increasing number of git-blame
"false positives" are more than enough.

    Alexey
