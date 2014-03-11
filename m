Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaCKN1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:27:21 -0400
Received: from mout.web.de ([212.227.15.3]:55293 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbaCKN1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:27:17 -0400
Date: Tue, 11 Mar 2014 14:27:06 +0100
From: Julian Wollrath <jwollrath@web.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
Message-ID: <20140311142706.27b2ad75@ilfaris>
In-Reply-To: <1394465314.12752.18.camel@x220>
References: <20140310110410.5b2218f6@ilfaris>
	<1394447253.2979.12.camel@x220>
	<alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de>
	<1394465314.12752.18.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:POMZiI5Ju997TXjPfA/g/OG3/F0acsEbclv60GLS+pvRij6Rk9y
 wIOgT70J99gqdxd8Z0qxJG8t8+05OmpiVQDK4PcKFYpOEElH0Nwv4+CcTQG1NErIslMb0yq
 EWTxEk5KkMrFw4ssg08hI/tqWDIJNaiyLn7KCw6tfmYKqOvjG/zmysZMOFE3U4uN9ww7M/h
 UJb0Vt96A+pTAUQJZfeFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mon, 10 Mar 2014 16:28:34 +0100
schrieb Paul Bolle <pebolle@tiscali.nl>:
> So I'm basically advising Julian to
> double check whether this is really a change in behavior between
> v3.13 and v3.14-rc1. But perhaps Julian already did.
Yes, I did and it happens reliably on every boot with v3.14-rc1.


Cheers,
Julian Wollrath
