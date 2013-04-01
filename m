Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab3DADtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:49:40 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:34731 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756242Ab3DADtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:49:39 -0400
Date: Mon, 1 Apr 2013 09:19:25 +0530
From: Shiraz Hashim <shiraz.hashim@st.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] pwm: spear: Fix enable pwm output
Message-ID: <20130401034925.GA21313@localhost.localdomain>
References: <1364621848.3568.0.camel@phoenix>
 <CAKohpo=xQC_pzc19RP1TncO3XJLj7k-_JyvT3n9UZFTEjYOizw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpo=xQC_pzc19RP1TncO3XJLj7k-_JyvT3n9UZFTEjYOizw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 05:55:41PM +0800, Viresh Kumar wrote:
> On 30 March 2013 11:07, Axel Lin <axel.lin@ingics.com> wrote:
> > The logic to check return value of clk_enable() is reversed, thus
> > when clk_enable() passes PWMCR_PWM_ENABLE bit is not set. Fix it.
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > ---
> >  drivers/pwm/pwm-spear.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> I am so sorry. clk_prepare also has the same issue :(
> Please fix that too and i will ack it ASAP.
> 
> @Shiraz: Any idea how they went through?

I don't remember how :(, surely a mistake which escaped tests also.

--
regards
Shiraz
