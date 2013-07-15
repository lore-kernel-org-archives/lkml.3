Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab3GOKVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:21:53 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33135 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3GOKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:21:52 -0400
MIME-Version: 1.0
In-Reply-To: <51E3C950.90503@linux.vnet.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
	<20130711221704.547.64296.stgit@srivatsabhat.in.ibm.com>
	<CAKohpom+WcTcefCZitgZQcSjTPsgXsa6VKQF5y6GJA31-rBm0w@mail.gmail.com>
	<51E3C950.90503@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 15:51:51 +0530
Message-ID: <CAKohponudZ+f=0k9xYhHv3FAKv3Mw6Lc-4MoV9+++VqBsvCNDg@mail.gmail.com>
Subject: Re: [PATCH 7/8] cpufreq: Preserve policy structure across suspend/resume
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

On 15 July 2013 15:35, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Actually even I was wondering about this while writing the patch and
> I even tested shutdown after multiple suspend/resume cycles, to verify that
> the refcount is messed up. But surprisingly, things worked just fine.

What kind of system have you tested it on?
