Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936808Ab3DJI5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:57:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab3DJI5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:57:23 -0400
Date: Wed, 10 Apr 2013 10:57:18 +0200
From: Michal Marek <mmarek@suse.cz>
To: Darren Hart <dvhart@linux.intel.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Bruce Ashfield <bruce.ashfield@windriver.com>
Subject: Re: [PATCH] merge_config.sh: Avoid creating unnessary source
 softlinks
Message-ID: <20130410085718.GA17541@sepie.suse.cz>
References: <1365102179-19176-1-git-send-email-john.stultz@linaro.org>
 <515EED40.9000102@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515EED40.9000102@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 08:26:56AM -0700, Darren Hart wrote:
> 
> 
> On 04/04/2013 12:02 PM, John Stultz wrote:
> > Viresh noticed when using merge_config.sh that a source softlink
> > was being created even when he didn't specify the -O option.
> > 
> > The problem arises due to the previous commit 409f117e2d6b
> > which added the -O option. Basically if -O is not specified,
> > we still pass '-O=.' to the make command, which then generates
> > a source softlink to ./
> > 
> > This patch adds an extra check so if there is no -O specified
> > to merge_config.sh, we don't pass one on to make.
> > 
> > Cc: Zhangfei Gao <zhangfei.gao@linaro.org>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: Bruce Ashfield <bruce.ashfield@windriver.com>
> > Cc: Darren Hart <dvhart@linux.intel.com>
> > Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> 
> Thanks John!
> 
> Acked-by: Darren Hart <dvhart@linux.intel.com>

Added to kbuild.git#kconfig.

Michal
