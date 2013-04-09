Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937263Ab3DIJv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:51:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:23113 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934741Ab3DIJv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:51:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="283580451"
Date: Tue, 9 Apr 2013 11:51:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Dong Aisheng <dong.aisheng@linaro.org>
Subject: Re: [PATCH] mfd: syscon: Add missing struct device_node declaration
Message-ID: <20130409095154.GO24058@zurbaran>
References: <1364230583-4043-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364230583-4043-1-git-send-email-s.nawrocki@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Silwester,

On Mon, Mar 25, 2013 at 05:56:23PM +0100, Sylwester Nawrocki wrote:
> syscon.h header uses struct device_node in functions' declarations
> without declaring it. This causes compilation warnings like:
> 
> include/linux/mfd/syscon.h:20: warning: ‘struct device_node’
> declared inside parameter list
> include/linux/mfd/syscon.h:20: warning: its scope is only this
> definition or declaration, which is probably not what you want
> 
> Fix it by adding a forward declaration of struct device_node.
> 
> Cc: Dong Aisheng <dong.aisheng@linaro.org>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/linux/mfd/syscon.h |    2 ++
>  1 file changed, 2 insertions(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
