Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3IMOLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:11:34 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:32921 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab3IMOLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:11:32 -0400
Date: Fri, 13 Sep 2013 16:11:23 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 017/228] cpufreq: cris: use
 cpufreq_table_validate_and_show()
Message-ID: <20130913141122.GD32443@axis.com>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
 <004c82aa4bdb721a03b38b3b5ef5fe7ca7841773.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004c82aa4bdb721a03b38b3b5ef5fe7ca7841773.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 02:59:23PM +0200, Viresh Kumar wrote:
> Lets use cpufreq_table_validate_and_show() instead of calling
> cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: Mikael Starvik <starvik@axis.com>
> Cc: linux-cris-kernel@axis.com
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
