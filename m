Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab3FNELP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 00:11:15 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:49188 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3FNELN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 00:11:13 -0400
MIME-Version: 1.0
In-Reply-To: <51BA7BDB.9070801@samsung.com>
References: <1370419882-16831-1-git-send-email-cw00.choi@samsung.com>
	<11735265.3zXb8Z81XT@vostro.rjw.lan>
	<CAKohpomwDonECPOPoSZvrOS+mRyNARX4Sk1XoEAGLXrOQQjYjA@mail.gmail.com>
	<2801243.ZfLEluCnpU@vostro.rjw.lan>
	<51BA7BDB.9070801@samsung.com>
Date: Fri, 14 Jun 2013 09:41:13 +0530
Message-ID: <CAKohpokL1PNsYXJvnrkYesUHhe4s9-HsZe_c5KW+toeHJep2PA@mail.gmail.com>
Subject: Re: [RESEND][PATCH] cpufreq: stats: Add 'load_table' sysfs file to
 show accumulated data of CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 June 2013 07:41, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> OK, I will reimplement load_table node by using debugfs instead of sysfs.

@Rafael: Would it be move trans_table to debugfs??
