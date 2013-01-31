Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3AaW1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:27:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40864 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3AaW1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:27:01 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-3e-510aefb37748
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
 <1358257112-19595-3-git-send-email-gautam.vivek@samsung.com>
 <2542030.a14I18dBkO@flatron>
In-reply-to: <2542030.a14I18dBkO@flatron>
Subject: RE: [PATCH v4 2/4] ARM: Exynos5250: Enabling ohci-exynos driver
Date: Thu, 31 Jan 2013 14:26:51 -0800
Message-id: <0b0001ce0002$12ecda90$38c68fb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJEIxpz/CmB/m1IOaI9mgyw8JBKXgHLtojJAldm8kWXVA+1sA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zY93N77kCDbrWmltc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjFZZOSmpNZllqkb5fAlXHrmGZBD0dFW+sDpgbGfrYuRk4OCQETiY+T
	fkHZYhIX7q0Hsrk4hASWMUoc+naNHaZoTv8xFojEIkaJxmv3GUESQgJ/GSXW75YAsdkENCQO
	v38G1iAiECbRu2kyO0gDs8A5RonHj1YijF379DkTSBWngKbEyevvwWxhAQ+JqeuPgk1lEVCV
	aPkykwXE5hWwlDj/5xI7hC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMkOcqiCx4+xrRogrnCQu
	nLnADFEjLjHpwUOwiyQE1rFLLN7+HGqZgMS3yYeAhnIAJWQlNh2AmiMpcXDFDZYJjBKzkKye
	hWT1LCSrZyFZsYCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGSMRJ7WBc2WBxiFGAg1GJ
	h1fDkTNQiDWxrLgy9xCjBAezkgjvzRdcgUK8KYmVValF+fFFpTmpxYcYk4GOncgsJZqcD0wG
	eSXxhsbGJmYmpibmlqbmpqQJK4nzMp56EiAkkJ5YkpqdmlqQWgSzhYmDU6qB0dydiVtpypbP
	UqqdQVn88enfdrTPnxSx4dikJdpv8k9VZ33Leeuw4mLh1EUW6euXLrtlpP5hu5nMBovrbXHr
	+YqnFB1SctI8N+/CBcEnLmfMHZIkZ5dfVmEpOMXDk/quK9wpbc6el3OWSfYtv7XypFui2kIz
	1ZacfzfsBDyCfrxfUfdj247yKUosxRmJhlrMRcWJAPSCfyL8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd3N77kCDe7/NbC4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj1jHN
	gh6OirbWB0wNjP1sXYycHBICJhJz+o+xQNhiEhfurQeKc3EICSxilGi8dp8RJCEk8JdRYv1u
	CRCbTUBD4vD7Z+wgtohAmETvpsnsIA3MAucYJR4/WgnVvYxRYu3T50wgVZwCmhInr78Hs4UF
	PCSmrj8KNpVFQFWi5ctMsNW8ApYS5/9cYoewBSV+TL4HFmcW0JJYv/M4E4QtL7F5zVtmiFMV
	JHacfc0IcYWTxIUzF5ghasQlJj14yD6BUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIEx/MzqR2MKxssDjEKcDAq8fBqOHIGCrEmlhVX5h5ilOBgVhLhvfmC
	K1CINyWxsiq1KD++qDQntfgQYzLQpxOZpUST84GpJq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZT
	TwKEBNITS1KzU1MLUotgtjBxcEo1MBaVZUQdUT/EszuOm+G3EP/hU1NM/8jf/J1//Hb8IaWO
	zx2VO35/c79wi+dNS4u77f/yEOlEAT0jmzNSKlUXv9961hel3thybicHu/gNR8XIvKiAo+dK
	eplPLdKOn/Xjs2Nlpd/jwvht107VXrH7y9jPnbruSPC1eS0ijwTsK2XebbJ/cebAFyWW4oxE
	Qy3mouJEAFuyOcYrAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Hi Vivek,

[...]

> > +	usb@12120000 {
> > +		compatible = "samsung,exynos4210-ohci";
> > +		reg = <0x12120000 0x100>;
> > +		interrupts = <0 71 0>;
> 
> For Samsung platforms we decided per board enabling of nodes and so this
> node should also contain:
> 
> 		status = "disabled";
> 
> while in dts file of board using ohci there would be an overriding entry:
> 
> 	usb@12120000 {
> 		status = "okay";
> 	};
> 
> I know that Exynos5250 has not been yet converted into this convention,
> but using it when adding new devices will simplify the process.
> 
Well, I have another opinion on this...

Let's see, yeah, we are using following method in EXYNOS4 DT...
- disabling IPs in SoC DT source and enabling IPs in board DT source

But as I said, in EXYNOS5440 DT, I want to use following, because most of
them should be enabled/used.
- enabling IPs in SoC DT source and no need enabling in board DT source.

I mean, it depends on each SoC's situation.

Thanks.

- Kukjin

