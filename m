Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3IZILR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:11:17 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:32779 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3IZILP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:11:15 -0400
MIME-Version: 1.0
In-Reply-To: <5243E866.1000909@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<c79ae2ab0a5a3946fcd0e68c855742f06f695f0f.1379779777.git.viresh.kumar@linaro.org>
	<52435DA4.3080204@linaro.org>
	<CAKohpokM2JLyjq3cTw=GMDx8S+_fZU1qxxavKoZ-roC2PXukNA@mail.gmail.com>
	<5243E866.1000909@linaro.org>
Date: Thu, 26 Sep 2013 13:41:14 +0530
Message-ID: <CAKohpom7sOxp_rJzojHZ1zLDYDHKRFeOB7ULKATOMFmOfYG+HQ@mail.gmail.com>
Subject: Re: [PATCH 11/21] cpuidle: replace multiline statements with single
 line in cpuidle_idle_call()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 13:25, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> Well I have 81 with Vi and 80 with Emacs :)

Hmm.. vim gave me 80 :) .. I am looking at bottom right corner where it gives:
148, 66-80 22%
