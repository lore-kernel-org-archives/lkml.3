Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbaGNMog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:44:36 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:39647 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbaGNMo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:44:28 -0400
Date: Mon, 14 Jul 2014 09:43:36 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Nicolas Del Piano <ndel314@gmail.com>
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cpufreq: ARM IMX6Q: Select PM_OPP
Message-ID: <20140714124336.GA1763@arch.cereza>
References: <1405288740-3986-1-git-send-email-ndel314@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405288740-3986-1-git-send-email-ndel314@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nico,

On 13 Jul 06:59 PM, Nicolas Del Piano wrote:
> PM_OPP is a library used by several of the existing cpufreq drivers.
> ARM IMX6Q cpufreq driver uses this library for its functionality.
> Thus, it should be selected in Kconfig.
> 
> Reported-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>

Thanks for the patch. I have just a very minor nitpick to comment;
if you run a git log, you'll see the subject should be:

"cpufreq: imx6q: Select PM_OPP"

In general, it's better to see the recent commits to find out how to write
the commit title; each driver can have its own style.
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
