Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763318Ab3DDQms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:42:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763114Ab3DDQmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:42:47 -0400
From: Thomas Renninger <trenn@suse.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V4 0/2] cpufreq: ondemand: add AMD specific powersave bias
Date: Thu, 04 Apr 2013 18:42:41 +0200
Message-ID: <2097539.ScIVCEFJgr@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
References: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 04, 2013 11:19:02 AM Jacob Shin wrote:
> This patchset adds AMD specific powersave bias function to the ondemand
> governor; which can be used to help ondemand governor make more power
> conscious frequency change decisions based on feedback from hardware
> (availble on AMD Family 16h and above).

Either the one way:
  1) Documenting powersave_bias and add the stuff there, best with a default
      set so that the stuff gets used
or
  2) Marking powersave_bias deprecated and embed things into ondemand
      directly

should be fine.

As you give this some usefulness now and it's going to get
used (automatically) and the stuff is even documented, I cannot suggest
anything anymore how to integrate that better.

Acked-by: Thomas Renninger <trenn@suse.de>

