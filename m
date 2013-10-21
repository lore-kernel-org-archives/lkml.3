Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3JUGKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 02:10:49 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:37779 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3JUGKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 02:10:47 -0400
MIME-Version: 1.0
In-Reply-To: <CACEExnLEFAThiosbptfThkjjK+27XTz+BuvSCMruYDcwmOkhRQ@mail.gmail.com>
References: <CACEExnLEFAThiosbptfThkjjK+27XTz+BuvSCMruYDcwmOkhRQ@mail.gmail.com>
Date: Mon, 21 Oct 2013 11:40:45 +0530
Message-ID: <CACEExnJJK803EQnVs3sfCOs7fs6-4rmOUsTibA27H3ArGJfrrA@mail.gmail.com>
Subject: Fwd: CPU usage
From: =?UTF-8?B?546L56We?= <oujin.rera@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am running a userspace tool that reads/writes ISO data from a USB
device. ( ISO means periodic data). I am measuring load created by the
tool using 'top' tool which shows CPU usage as 0% sometimes and 40%
sometimes.

If the data is periodic why the CPU usage vary so much ? Can any one
point out what is the missing link ? Does any have a better approach
to measure CPU usage.

Thanks in Advance
