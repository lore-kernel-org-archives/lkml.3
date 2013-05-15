Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab3EOORk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:17:40 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34110 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759141Ab3EOORj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:17:39 -0400
MIME-Version: 1.0
Date: Wed, 15 May 2013 16:17:39 +0200
Message-ID: <CAHxi25cVgA_AUpx4rR_LY5y19s+FCE-RhF62qM5DEJYz6EHzQg@mail.gmail.com>
Subject: EPOLL_CTL_DEL epoll_event struct data
From: Fredrik Asberg <aasberg.fredrik@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, as a user of linux epoll I have come across situations where it
would have been nice
if the data associated with a file descriptor would have been returned
upon deletion.

Since epoll_ctl already takes a pointer to a epoll_event struct is
there any reason
why the data member is not set when the pointer is not null.
