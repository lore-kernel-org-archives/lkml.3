Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab3I0DTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:19:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16090 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3I0DTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:19:37 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-41-5244f9472983
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>
Cc: "'Mike Dunn'" <mikedunn@newsguy.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        "'Robert Jarzmik'" <robert.jarzmik@free.fr>,
        "'Marek Vasut'" <marex@denx.de>, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com>
 <5244065A.8010408@ti.com> <20130926115108.GA1680@ulmo>
 <524423B6.4070609@ti.com> <20130926125953.GB2141@ulmo>
In-reply-to: <20130926125953.GB2141@ulmo>
Subject: Re: [PATCH v2] pwm-backlight: allow for non-increasing brightness
 levels
Date: Fri, 27 Sep 2013 12:19:35 +0900
Message-id: <017601cebb30$642ce050$2c86a0f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66uKCCJojmUc+CSs2qtZgLfVEwXAAbuPEQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zQ133ny5BBnMWaVjMP3KO1eLAnx2M
	FpcXXmK1ONH3gdXi8q45bBZ3765itHjT1shosfbVTzaLdQ9fMFkcXnGAyWLWG2GL3bueslr8
	3DWPxWL9/FtsDnweCz5fYfeYN+sEi0f/us+sHjtn3WX3eHXhDovHnWt72DyWXH/P6rFn/g9W
	j74tqxg9jt/YzuTxeZNcAHcUl01Kak5mWWqRvl0CV8bcFRvYCx5LVhzY9o61gXGqSBcjJ4eE
	gInEojM3WSBsMYkL99azgdhCAssYJaa21MLUTLvxAKiGCyi+iFHi78VDrBDOL0aJRffesYNU
	sQmoSXz5chjMFhGIlri+8TU7SBGzwHFmiS+NDcwQHdsYJfa+mcwEUsUpoCnx+O0jsA5hgWCJ
	3xvegtksAqoSUybOBrN5BWwlTi5qZoKwBSV+TL4HdiuzgJbE+p3HmSBseYnNa94CLeAAulVd
	4tFfXYgjjCQe3b/GBlEiIrHvxTtGkBskBM5wSNzb18ACsUtA4tvkQywQvbISmw4wQ7wsKXFw
	xQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkgC6d3B
	ePuA9SHGZKD1E5mlRJPzgQkoryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2MuelP+PbbPLzzsWZHHmP0eWWmP1/WNN5S3rI59pDArYpfBc8/50tJ
	HrB78KbqrqJDhWPpMws1L50j5iJ2+41ZD+2b2/56xzkx/vWLIr/c5ljE7/Mz/cuf1az/vewi
	FsiVek9QvZub3LBdPukTM1fM7fN9N5/6q3H357y8N3Ny570PLT1ZQStnKbEUZyQaajEXFScC
	AHtMRnw2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xgK77T5cgg5NHlCzmHznHanHgzw5G
	i8sLL7FanOj7wGpxedccNou7d1cxWrxpa2S0WPvqJ5vFuocvmCwOrzjAZDHrjbDF7l1PWS1+
	7prHYrF+/i02Bz6PBZ+vsHvMm3WCxaN/3WdWj52z7rJ7vLpwh8XjzrU9bB5Lrr9n9dgz/wer
	R9+WVYwex29sZ/L4vEkugDuqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkh
	LzE31VbJxSdA1y0zB+gPJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG
	3BUb2AseS1Yc2PaOtYFxqkgXIyeHhICJxLQbD1ggbDGJC/fWs3UxcnEICSxilPh78RArhPOL
	UWLRvXfsIFVsAmoSX74cBrNFBKIlrm98zQ5SxCxwnFniS2MDM0THNkaJvW8mM4FUcQpoSjx+
	+wisQ1ggWOL3hrdgNouAqsSUibPBbF4BW4mTi5qZIGxBiR+T74HdxCygJbF+53EmCFteYvOa
	t0ALOIBuVZd49FcX4ggjiUf3r7FBlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQITlDPpHYwrmywOMQowMGoxMMrkOESJMSaWFZcmXuIUYKD
	WUmEd30sUIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgckzryTe0NjEzMjSyMzCyMTcnDRh
	JXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYN8+ZIBlxd+bMqrXl9htkfq1hZLl/cb9JCsPO
	WCmWKee61h3PzbG2nxc26XCYa9WCpJ/6nQ6nj20Wq682iV8jpH3mrN3e+ydd90xcuub9fva8
	EFGuBvfmcm3tJXLJ7+YwHVz4WINrdoXWNIH1lsfn+j2Ycon90K8C5aW9+Uc9Fa1Drz9q5GcJ
	VWIpzkg01GIuKk4EALcJE/GUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 10:00 PM, Thierry Reding wrote:
> On Thu, Sep 26, 2013 at 03:08:22PM +0300, Tomi Valkeinen wrote:
> > On 26/09/13 14:51, Thierry Reding wrote:
> > > On Thu, Sep 26, 2013 at 01:03:06PM +0300, Tomi Valkeinen wrote:
> > > [...]
> > >> But if you and Thierry think this version is good, I'll take it.
> > >
> > > That sounds like you want to take it through the fbdev tree. Jingoo is
> > > listed (along with Richard, but he hasn't been responsive to email for
> > > years) as maintainer for the backlight subsystem. Furthermore back at
> >
> > Ah, so they are. I just thought it falls under fbdev, as it's under
> > drivers/video/ =).
> >
> > I don't have any particular "want" to take it through fbdev tree. But I
> > can take it.
> >
> > > the time when I began working on the PWM subsystem, the backlight sub-
> > > system was pretty much orphaned, and pwm-backlight was by far the
> > > biggest user of the PWM subsystem. I adopted the driver at the time
> > > because it needed to be updated for PWM subsystem changes.
> > >
> > > What's the plan going forward? Given the coupling between the PWM
> > > subsystem and the pwm-backlight driver it might be useful to keep
> > > maintaining it as part of the PWM subsystem. On the other hand, there's
> > > some coupling between the driver and the backlight subsystem too.
> >
> > And backlight is coupled with fbdev... Which is something I don't like.
> >
> > > I have a couple of patches queued up for 3.13 that rework parts of the
> > > driver, so it'd be good to know how you guys want to handle this.
> >
> > Well. I'm happy if somebody wants to maintain the backlight side. In
> > fact, I'd be happy if somebody would start restructuring it totally,
> > it's rather messy. The link with fbdev should be removed, and some
> > backlight drivers are actually panel drivers. However, perhaps Common
> > Display Framework is required until it can be fully cleaned.
> >
> > So... For the time being, I'm fine with merging pwm-backlight via any
> > tree that works best. I'm presuming here that backlight framework and
> > fbdev (for the parts that are relevant for backlight) are not really
> > being changed, so there shouldn't be conflicts.
> 
> In that case I'll just take it through the PWM tree as I've done for the
> past year. I have some other changes planned for the PWM framework for
> the near future that'll create dependencies between the PWM tree and the
> pwm-backlight driver, so keeping them in one tree will make it easier to
> merge them.

Yes, I think so.
I want you to take the patches for pwm-backlight through the PWM tree,
as you have done.

> 
> Longer term it probably makes sense, as you say, for someone to take
> over the backlight subsystem completely and give it the love it could
> really use. If Jingoo can do that, it'd be great. Perhaps it'd be a good
> idea to remove Richard as maintainer since he's obviously no longer
> responding to emails. Keeping him Cc'ed on all patches is just
> pointless.

OK, I will send the patch to remove Richard as maintainer.

I will make a git tree and mailing-list for the backlight subsystem later.
However, I am not certain when it will be done. :-(

Best regards,
Jingoo Han

