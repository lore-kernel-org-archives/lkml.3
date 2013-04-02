Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3DBTY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:24:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49873 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3DBTYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:24:24 -0400
Date: Tue, 2 Apr 2013 21:24:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH V3 1/2] cpufreq: ondemand: allow custom
 powersave_bias_target handler to be registered
Message-ID: <20130402192417.GD17675@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Thomas Renninger <trenn@suse.de>
References: <1364926304-1799-1-git-send-email-jacob.shin@amd.com>
 <1364926304-1799-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364926304-1799-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 01:11:43PM -0500, Jacob Shin wrote:
> This allows for another [arch specific] driver to hook into existing
> powersave bias function of the ondemand governor. i.e. This allows AMD
> specific powersave bias function (in a separate AMD specific driver)
> to aid ondemand governor's frequency transition deicisions.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
