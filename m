Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764839Ab3DDUaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:30:07 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:45071
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764807Ab3DDUaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:30:04 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKQZLO-02-42X-02
X-M-MSG: 
Date: Thu, 4 Apr 2013 15:29:47 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH V4 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130404202947.GB24479@jshin-Toonie>
References: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
 <1365092344-11310-3-git-send-email-jacob.shin@amd.com>
 <20130404192323.GI32271@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130404192323.GI32271@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 09:23:23PM +0200, Borislav Petkov wrote:
> On Thu, Apr 04, 2013 at 11:19:04AM -0500, Jacob Shin wrote:
> > Future AMD processors, starting with Family 16h, can provide software
> > with feedback on how the workload may respond to frequency change --
> > memory-bound workloads will not benefit from higher frequency, where
> > as compute-bound workloads will. This patch enables this "frequency
> > sensitivity feedback" to aid the ondemand governor to make better
> > frequency change decisions by hooking into the powersave bias.
> > 
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> 
> Looks good to me.
> 
> Acked-by: Borislav Petkov <bp@suse.de>

Rafael, got acks from both Boris and Thomas. Please commit to
linux-next when you get the chance.

Thanks,

-Jacob

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

