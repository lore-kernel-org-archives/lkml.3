Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967952AbaLLNYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:24:24 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:33375 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967664AbaLLNYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:24:22 -0500
Message-ID: <1418390652.2470.47.camel@sipsolutions.net>
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Krzysztof Konopko <kris@konagma.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Dec 2014 14:24:12 +0100
In-Reply-To: <548AD2F1.3080200@konagma.com> (sfid-20141212_123521_918435_E1E26083)
References: <1418336609-10191-1-git-send-email-kris@konagma.com>
	 <548A2E7A.4010303@lwfinger.net> <548AD2F1.3080200@konagma.com>
	 (sfid-20141212_123521_918435_E1E26083)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-12 at 12:35 +0100, Krzysztof Konopko wrote:

> I'm _far_ from being a wireless expert but doesn't data coming out of
> the wire/air have the endianess defined explicitly?  And both `AC_param`
> and `ADDBA_request` come out of air?

In general, data in 802.11 frames is little endian. Both of these would
appear to correspond to data received/sent over the air, so __le would
make sense.

johannes


