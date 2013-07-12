Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3GLHR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:17:58 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:54250 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab3GLHR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:17:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130711221623.547.5846.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
	<20130711221623.547.5846.stgit@srivatsabhat.in.ibm.com>
Date: Fri, 12 Jul 2013 12:47:56 +0530
Message-ID: <CAKohpo=VoWyJSKZt9DypmG16m14sAnJCWZ25F2d09heB8iK0iw@mail.gmail.com>
Subject: Re: [PATCH 4/8] cpufreq: Extract non-interface related stuff from cpufreq_add_dev_interface
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, toralf.foerster@gmx.de, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 July 2013 03:46, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> cpufreq_add_dev_interface() includes the work of exposing the interface
> to the device, as well as a lot of unrelated stuff. Move the latter to
> cpufreq_add_dev(), where it is more appropriate.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c |   43 ++++++++++++++++++++++++++-----------------
>  1 file changed, 26 insertions(+), 17 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
