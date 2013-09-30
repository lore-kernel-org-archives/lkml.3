Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3I3SQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:16:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51174 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab3I3SQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:16:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tixy@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] cpufreq: make return type of lock_policy_rwsem_{read|write}() as void
Date: Mon, 30 Sep 2013 20:28:21 +0200
Message-ID: <2382588.IckWbq3JRN@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <a257808b511a83f210ed699149ce87fef5db6236.1379344038.git.viresh.kumar@linaro.org>
References: <075032be4fd288074b8f699d4f4ba0179518df6f.1379344038.git.viresh.kumar@linaro.org> <a257808b511a83f210ed699149ce87fef5db6236.1379344038.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 16, 2013 08:40:17 PM Viresh Kumar wrote:
> lock_policy_rwsem_{read|write}() currently has return type of int but it always
> return zero and hence its return type must be void instead. This patch makes its
> return type void and fixes all users of it as well.
> 
> Reported-by: Jon Medhurst<tixy@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

This doesn't apply to bleeding-edge for me any more after I have applied your
series of 44 patches to it.  Care to resend?

Rafael

