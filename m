Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbbANN5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:57:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50327 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbbANN5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:57:02 -0500
X-AuditID: cbfee61a-f79c06d000004e71-3f-54b675ab6944
Date: Wed, 14 Jan 2015 14:56:32 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Cc: Guenter Roeck <linux@roeck-us.net>, Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/9] hwmon: dts: Doc: Add DTS doc to explain how to use PWM
 FAN as a cooling device
Message-id: <20150114145632.3010f836@amdc2363>
In-reply-to: <1420455034.15910.53.camel@collabora.co.uk>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1418897591-18332-3-git-send-email-l.majewski@samsung.com>
 <1418899337.23532.9.camel@collabora.co.uk> <20141219163224.34796e5d@amdc2363>
 <20141219160237.GA2199@roeck-us.net> <20141219171301.1527d81e@amdc2363>
 <1420455034.15910.53.camel@collabora.co.uk>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jQd3VpdtCDH6skLKYf+Qcq8X8K9dY
	LZbe/cRm8eP1BTaL3gVX2SzePOK2uLxrDpvF594jjBYzzu9jsniy8AyTxZ1pe9ksDr9pZ7WY
	fvwtqwOvx9/n11k8ds66y+7xYOJuNo91094ye+z83sDu0bdlFaPH5tPVHp83yQVwRHHZpKTm
	ZJalFunbJXBl7JzxhqlglkbF9HMXWBsY58p1MXJySAiYSLxfc5kNwhaTuHBvPZDNxSEkMJ1R
	ou/AayYI5xejxIoPUxlBqlgEVCX+rlzKAmKzCehJfL77lAnEFhEwlPgx5wsjSAOzwENmiSPN
	74AcDg5hgUyJx838IDW8QPWHtpxiBrE5BSwkOn90Qy04zSQx+9dkVpAEv4CkRPu/H8wQJ9lJ
	nPu0gR2iWVDix+R7YIuZBbQkNm9rYoWw5SU2r3nLPIFRcBaSsllIymYhKVvAyLyKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIziunkntYFzZYHGIUYCDUYmH1+HI1hAh1sSy4srcQ4wSHMxK
	IrxpcttChHhTEiurUovy44tKc1KLDzFKc7AoifMq2beFCAmkJ5akZqemFqQWwWSZODilGhgz
	bS9P3553/5Nms3EtV0qQWEqo0ds/Ta4t7sKO72ak+rpZXHBl1eZ982rx7Dn779xfPvPIp5dy
	EkETy8UuLlnjJqiQsnhxxEFd7Qf3tjR3v2dp+TiF6aad2hxzvdaZD7v+L1n+O4X/l8D29a6s
	WeIvzjWseWtSedpu3ambei4zltf9D+XSMGJUYinOSDTUYi4qTgQAfR7ci6cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjoerd,

> Hey Lukasz,
> 
> Blame the holiday season for my late reply ;)
> 
> On Fri, 2014-12-19 at 17:13 +0100, Lukasz Majewski wrote:
> > Hi Guenter,
> > 
> > > On Fri, Dec 19, 2014 at 04:32:24PM +0100, Lukasz Majewski wrote:
> > > > Hi Sjoerd,
> > > > 
> > > > Thanks for your feedback and sorry for a late reply.
> > > > 
> > > > > On Thu, 2014-12-18 at 11:13 +0100, Lukasz Majewski wrote:
> > > > > > Several new properties to allow PWM fan working as a cooling
> > > > > > device have been combined into this single commit.
> > > > > > 
> > > > > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > > > > > ---
> > > > > >  .../devicetree/bindings/hwmon/pwm-fan.txt          | 28
> > > > > > ++++++++++++++++++++++ 1 file changed, 28 insertions(+)
> > > > > > 
> > > > > > diff --git
> > > > > > a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> > > > > > b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt index
> > > > > > 610757c..3877810 100644 ---
> > > > > > a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt +++
> > > > > > b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt @@
> > > > > > -3,10 +3,38 @@ Bindings for a fan connected to the PWM
> > > > > > lines Required properties:
> > > > > >  - compatible	: "pwm-fan"
> > > > > >  - pwms		: the PWM that is used to control the
> > > > > > PWM fan +- cooling-pwm-values      : PWM duty cycle values
> > > > > > relative to
> > > > > > +			    cooling-max-pwm-value
> > > > > > correspondig to
> > > > > > +			    proper cooling states
> > > > > > +- default-pulse-width     : Property specifying default
> > > > > > pulse width for FAN
> > > > > > +			    at system boot (zero to disable
> > > > > > FAN on boot).
> > > > > > +			    Allowed range is 0 to 255
> > > > > 
> > > > > The 0..255 range seems somewhat random. Would be nicer to
> > > > > either use the approach of pwm-backlight (iotw, have the
> > > > > range go from the first to the last entry of
> > > > > cooling-pwm-values) 
> > > > 
> > > > I'm OK to change the default-pulse-width to be similar to
> > > > "default-brightness-level" (as it is in
> > > > Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt)
> > > > 
> > > > > or simply have be the duty
> > > > > lenght in NS as entries instead of the current indirection.
> > > > 
> > > > I'd prefer to keep the indirection - as it is utilized in the
> > > > current pwm-fan.c driver.
> > > > 
> > > FWIW, devicetree information is supposed to be implementation
> > > independent. So this is a poor argument.
> > 
> > Many other pwm drivers use the indirection - e.g. mentioned
> > pwm-backlight.
> 
> I don't specifically mind the indirection, i was just thinking out
> loud whether it added value (but if it's quite common, might indeed
> be good to keep the pattern). What i do dislike is the number of
> levels is being set to an arbitrary levels, as that will very rarely
> match the actual number of distinct pwm levels you 
> 
> One thing though, when following the pattern of the pwm-backlight
> driver; In pwm-backlight the highest index of brightness-levels is
> always 100% duty cycle.. On e.g. XU3 the vendor kernel never drives
> the fan at 100% duty (maximum of 91%). So it would be nice if the dt
> bindigns could model that e.g. by having:
> 
> pwm-levels = <20>; // 21 distinct pwm levels
> valid-pwm-level = <5 15 18>; /* 5 15 and 18 are usable levels - pwm
> will default to highest level */
> 

Could you review v2 of this patch series?

http://www.spinics.net/lists/devicetree/msg63159.html

> 
> > > > Enabling pan to full RPM was the default behaviour in the
> > > > current pwm-fan.c file.
> > > > 
> > > > To be honest, there is no need to enable fan to full RPM speed
> > > > in this board for following reasons:
> > > > 1. In Odroid the FAN is optional (stacked on top of a heat
> > > > sink) - very often it is just enough to only have the heat sink.
> > > > 
> > > > 2. Odroid has thermal enabled by default and IMHO it would be
> > > > more feasible to allow thermal to control fan from the very
> > > > beginning.
> > > > 
> > > > However, I can also understand if the policy for hwmon implies a
> > > > rule to enable by default all fans to full RPM speed.
> > > > 
> > > Why and how does that all suggest that the current default
> > > behavior should be changed ?
> > 
> > I wanted to avoid the unpleasant sound for full speed fan when
> > thermal is not enabled by default.
> > 
> > But as I said, I fully understand the policy and I would be happy to
> > comply with it as thermal should reduce the fan speed anyway at boot
> > time.
> 
> Yeah, what happens on my XU3 is that u-boot sets the pwm to 100% duty
> and the thermal infrastructure turns it off as soon as it gets into
> control, which works quite nicely (and keeps my sanity as that fan at
> 100% is *loud*)...  So if you want to avoid unpleasant sounds, just
> build with thermal :p
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
