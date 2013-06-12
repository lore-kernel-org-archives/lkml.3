Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3FLIoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:44:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57621 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab3FLIon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:44:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAFgnuDcs7AC7ZmF0xjCYsfj8R_X_cvhNR4V+bduPNhjHR3KQpQ@mail.gmail.com>
References: <1371021986-20985-1-git-send-email-chenxg@marvell.com>
	<CAKohpok2AEe3bL=mPAoxbenEBaWU=WjkRckbvcnzjnUwFZgnuA@mail.gmail.com>
	<CAFgnuDcs7AC7ZmF0xjCYsfj8R_X_cvhNR4V+bduPNhjHR3KQpQ@mail.gmail.com>
Date: Wed, 12 Jun 2013 14:14:43 +0530
Message-ID: <CAKohpomigrHOQ-FhuDZTTL3oBQjTDS1w9tK0PwbS6x=Op8=yTg@mail.gmail.com>
Subject: Re: [PATCH v3] cpufreq: fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: Xiaoguang Chen <chenxg@marvell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2013 14:13, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
> I thought about return one error code before. but I checked the code
> and found that
> most of the governor stop/start operations don't check the return
> value. I can add error code
> here, I think the checking of return value is also needed. May be
> another patch can do this.

Yeah.
