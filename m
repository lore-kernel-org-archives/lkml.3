Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750Ab3DCRRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:17:48 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:55472
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762172Ab3DCRRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:17:46 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKOW1G-01-4QF-02
X-M-MSG: 
Date: Wed, 3 Apr 2013 12:17:38 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, Thomas Renninger <trenn@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V3 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130403171738.GC17919@jshin-Toonie>
References: <1364926304-1799-1-git-send-email-jacob.shin@amd.com>
 <20130402192352.GC17675@pd.tnic>
 <20130402200337.GA17919@jshin-Toonie>
 <2932884.BNCEuERbdR@skinner.arch.suse.de>
 <20130402210124.GI17675@pd.tnic>
 <20130403165324.GB17919@jshin-Toonie>
 <20130403170456.GA4723@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130403170456.GA4723@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 07:04:56PM +0200, Borislav Petkov wrote:
> On Wed, Apr 03, 2013 at 11:53:24AM -0500, Jacob Shin wrote:
> > Then Thomas, Boris, would it be acceptable if enable the frequency
> > feedback feature by default with a sane powersave_bias tunable value?
> > And also add proper documentation for both vanila powersave_bias
> > and powersave_bias with AMD frequency sensitivity loaded to
> > Documentation/cpu-freq/ondemand ?
> 
> Yeah, this was what I was proposing, basically. The only question here
> is, would anyone want to disable freq decisions on systems with hw
> feedback? If yes, then you'd need to be able to disable the feedback
> thing, maybe have a magic value for powersave_bias...

Writing 0 to powersave_bias or unloading the AMD driver could do that.

When the AMD driver loads, it will give a sane default value to
powersave_bias to enable it, when it unloads, it will put it back to 0

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

