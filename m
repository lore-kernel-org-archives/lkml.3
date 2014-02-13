Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaBMAve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:51:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64800 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaBMAvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:51:32 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-57-52fc171197ae
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pavel Machek'" <pavel@ucw.cz>, "'Jenny Tc'" <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        "'Dmitry Eremin-Solenikov'" <dbaryshkov@gmail.com>,
        "'Anton Vorontsov'" <cbouatmailru@gmail.com>,
        "'Anton Vorontsov'" <anton.vorontsov@linaro.org>,
        "'Kim Milo'" <Milo.Kim@ti.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "=?ISO-8859-1?Q?'Pali_Roh=E1r'?=" <pali.rohar@gmail.com>,
        "'Rhyland Klein'" <rklein@nvidia.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Sebastian Reichel'" <sre@ring0.de>, aaro.koskinen@iki.fi,
        "'Pallala Ramakrishna'" <ramakrishna.pallala@intel.com>,
        freemangordon@abv.bg, linux-omap@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-3-git-send-email-jenny.tc@intel.com>
 <20140204113630.GC2450@amd.pavel.ucw.cz>
 <20140205081458.GA19586@jenny-desktop>
 <20140212110005.GF25706@amd.pavel.ucw.cz>
In-reply-to: <20140212110005.GF25706@amd.pavel.ucw.cz>
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Date: Thu, 13 Feb 2014 09:51:29 +0900
Message-id: <002301cf2855$bb121790$313646b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8n4Zga+NGj3gRyQmeomeXcaDh23gAc4WNw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0iTURjHOXvfvZsj4bg0TwO1hC6I96mdKEMq5KUMRPpgflnT3qbkrW2G
	fUoyy8RLui42zTs6r4EaqczbRNQW2TLN8BZq8zrDy8zUrM0Z+LVv/+c8v+f8/w88XII/xRZw
	o2LljDRWHO1M8Ujtjl7oZmO/HeI59+EkrpkNwLqUERK/7B/g4C9rM2ycM/2DwNmVCgJPGd1x
	rTGdgweKP7FxmaKQjSeM3QAPtORTOK8si8QjA9a4YrOOxNnaLRYee9dN4eLFryz8XmsaKO+p
	ZuO+7QyAK1ZCcfvnSwH2dHf/PJt+kJxO0evGHJJuVo5x6C5jMUk3qFzoUvUcix4dUlN02aKG
	TWckL1F0q2aDQzcOPiLpzMYqQPcMv2XRquqfHHq13jEYhvHO3mCio+4wUo9z13mRg9+NRHwn
	J7Eg9UgS0LPTgBUXQR+UaVACiz6EPo6/ptIAj8uH5QAta/+w/kFlyzrS0igBaHo4l2MpNgFS
	9WtIM0XB42htrYtj1rbwPCoxrLDMEAG1FJp+mkeYG3z4C6AdXbBZW0E/VKot3B04CINQVlHV
	7kckPIZerKp3eWvoj4y5S3vaBm0oxncZArqi9pTnlEU7oYYag4nhmqKeQJO/3SwZvNFSavke
	YovaZpeAOQ+C1Vao1qBmWbwgWleYFzDPOqD6DsKy8WHUqRomnwCk3Oes3Oes3Oes3GdRBMgq
	YMfER8TLwiVSX3eZOEaWECtxj4iLqQeWA8tuAhMdZzQgwmSfTQjsIuJMBxgrF3kJ/byxr4+v
	0PvUab//e3a2t5ZMhofwoUQsZ24xTDwjFUkTohmZBrC4VoIk0CXfuSLNeyM/2vww31XnXzA1
	pPcUJcGbAp5DlVOd6LbHGlws72kxfHOHRr3QYyow6tWzXqiXgPmriul+eRaxMdPkqb5W6n1Z
	hzc3k/gXx9vbau4vhOUKercD/UW+hYUT1qoNnwuOj/vs7tkFVQrvHmgObQ3WjW5puhYSyUZn
	UhYp9nIhpDLxX21DlaR2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsVy+t9jAV1B8T9BBj9fKlqseeFgcbH1NovF
	zPOX2S2uf3nOajHpyXtmi4krJzNbPP6qZ7H2aw+7xeWFl1gtlkyez2px/+tRRovLu+awWcxe
	0s9icfsyr8XyX+tYLCae/s1kcffUUTaLhW9uMlmcOQ3UsOz4alaLk396GS2Wf4qw2H/Fy0Hc
	4+j5V6weLc09bB7fvk5i8dg56y67x+GvC1k8Nq/Q8li85yWTx51re9g8lrw5xOrR2/yOzWPv
	oR/sHluutrN49G1Zxehx/MZ2Jo8Vq7+ze3zeJBcgENXAaJORmpiSWqSQmpecn5KZl26r5B0c
	7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDDAglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0R
	ur4hQXA9RgZoIGEdY8bVp1+ZCw6yV8zrUGhgfMbaxcjJISFgIrHk40UWCFtM4sK99WxdjFwc
	QgKLGCWe3JjBDuH8YpRYcf4QWBWbgJrEly+H2UFsEQEniUVvPzGBFDELnGaTeDJlNjNIQkjg
	J6PEv4sBIDangJnE4tPzwRqEBXwk+hesAhvEIqAqMf3zHrB6XgFbia8z3kHZghI/Jt8Dq2EW
	0JHY3zqNDcKWl9i85i1QDQfQqeoSj/7qQtxgJPGuYxlUiYjEvhfvGCcwCs1CMmkWkkmzkEya
	haRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg9PhMegfjqgaLQ4wCHIxKPLwPFv8O
	EmJNLCuuzD3EKMHBrCTCm8zwJ0iINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84GpO68k3tDY
	xMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGAPdXzwOsXypzam+e815
	BfO7Dg/THdTUvvNM8y8Ljp45OWr6ko0HrZ3Ti6ee/x2180WW5wbliGu8Ov8vHjnXLBd243lw
	ZqXQJOeXHspJ23hCLOWnX77047Xi3R1Zx/47pDndYzMOO76je3m2VfGJwF03FPiOem7yUFTL
	27lBf8LFvrJdlfaL9yuxFGckGmoxFxUnAgBL0NAB0wMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 12, 2014 8:00 PM, Pavel Machek wrote:
> On Wed 2014-02-05 13:44:58, Jenny Tc wrote:
> > On Tue, Feb 04, 2014 at 12:36:30PM +0100, Pavel Machek wrote:
> > > > +struct psy_charger_context {
> > > > +	bool is_usb_cable_evt_reg;
> > > > +	int psyc_cnt;
> > > > +	int batt_status;
> > > > +	/*cache battery and charger properties */
> > >
> > > Comment coding style. Please run you patches through checkpatch.
> >
> > checkpatch doesn't throw any error/warning. /* ... */ not allowed for single line
> > comments? (will fix missing space after /*)
> 
> I meant the space after /*. Maybe checkpatch does not report anything
> here, but I guess there are other places where it will comment :-).

Yes, right.

+	/*cache battery and charger properties */
           ^
'one space' is necessary between '/*' and 'cache'.
This can be fixed as below.
+	/* cache battery and charger properties */

Best regards,
Jingoo Han

