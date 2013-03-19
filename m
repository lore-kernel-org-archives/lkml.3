Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab3CSKeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:34:19 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:36594 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3CSKeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:34:18 -0400
MIME-Version: 1.0
Date: Tue, 19 Mar 2013 10:34:17 +0000
Message-ID: <CAEJHKkWJJ2YxQjh1+bvbObCit5tWmXWMyA1Y1AxN1YwLi0NQsw@mail.gmail.com>
Subject: squash based lvecd use swap
From: basteon <basteon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,
I've some troube with squash access after I made resume from swap.
I use it on livecd. Everyting works fine, but  can't use squash mounts
after resume, it says about Bus error.
Also I can't remount squash's images after resuming.
How can I fix that trouble.
I use 2.6.38 version of kernel.
