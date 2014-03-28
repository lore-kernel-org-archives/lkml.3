Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaC1WP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:15:26 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:59790
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbaC1WPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:15:24 -0400
X-Greylist: delayed 948 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2014 18:15:23 EDT
Message-ID: <1396043847.27583.3.camel@linux-builds1>
Subject: Re: [PATCH 1/2] dt/bindings: add binding for ARM Versatile
 character LCD
From: Dinh Nguyen <dinguyen@altera.com>
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>
Date: Fri, 28 Mar 2014 16:57:27 -0500
In-Reply-To: <CAL_JsqLKti+1WCvt2kAMpic0u1zRtVJ-ZBvp2BasPx847ZDKLQ@mail.gmail.com>
References: <1396041629-28820-1-git-send-email-robherring2@gmail.com>
	 <1396042524.27583.0.camel@linux-builds1>
	 <CAL_JsqLKti+1WCvt2kAMpic0u1zRtVJ-ZBvp2BasPx847ZDKLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?utf-8?B?Q0lQOjY2LjM1LjIzNi4yMzI7Q1RSWTpVUztJUFY6TkxJO0VGVjpOTEk7U0ZW?=
 =?utf-8?B?Ok5TUE07U0ZTOigxMDAxOTAwMSkoNjAwOTAwMSkoNDU4MDAxKSg1MTcwNDAw?=
 =?utf-8?B?NSkoMzc3NDI0MDA0KSgxOTkwMDIpKDE4OTAwMikoMzc3NDU0MDAzKSgyNDQ1?=
 =?utf-8?B?NDAwMikoOTg2NzYwMDEpKDYyOTY2MDAyKSg4NTg1MjAwMykoODcyODYwMDEp?=
 =?utf-8?B?KDU2ODE2MDA1KSg5MzEzNjAwMSkoODE1NDIwMDEpKDYzNjk2MDAyKSgyMDc3?=
 =?utf-8?B?NjAwMykoNTA0NjYwMDIpKDg1MzA2MDAyKSg4NDY3NjAwMSkoNzQ3MDYwMDEp?=
 =?utf-8?B?KDkyNzI2MDAxKSg4NzI2NjAwMSkoNDk4NjYwMDEpKDQzOTYwMDEpKDc0NTAy?=
 =?utf-8?B?MDAxKSg3NDM2NjAwMSkoNjkyMjYwMDEpKDUwOTg2MDAxKSg5MjU2NjAwMSko?=
 =?utf-8?B?NDc3MzYwMDEpKDgxODE2MDAxKSg0NDk3NjAwNSkoNjU4MTYwMDEpKDg3OTM2?=
 =?utf-8?B?MDAxKSg3OTEwMjAwMSkoNzcwOTYwMDEpKDc2Nzg2MDAxKSg4MzMyMjAwMSko?=
 =?utf-8?B?NDYxMDIwMDEpKDc2Nzk2MDAxKSg4MTY4NjAwMSkoNDc5NzYwMDEpKDk1NDE2?=
 =?utf-8?B?MDAxKSg4MTM0MjAwMSkoODAwMjIwMDEpKDk3NzM2MDAxKSg5NzMzNjAwMSko?=
 =?utf-8?B?OTcxODYwMDEpKDk0MzE2MDAyKSg3NzE1NjAwMSkoMzE5NjYwMDgpKDkzOTE2?=
 =?utf-8?B?MDAyKSgzMzcxNjAwMSkoOTU2NjYwMDMpKDE0MTEwMDEpKDMzNjQ2MDAxKSg1?=
 =?utf-8?B?NDMxNjAwMikoNTM4MDYwMDEpKDgwOTc2MDAxKSg1MDIyNjAwMSkoODk5OTYw?=
 =?utf-8?B?MDEpKDQ3Nzc2MDAzKSg3NDY2MjAwMSkoNTk3NjYwMDEpKDkwMTQ2MDAxKSg4?=
 =?utf-8?B?MzA3MjAwMikoNzQ4NzYwMDEpKDIzNjc2MDAyKSg2ODA2MDA0KSgyMDA5MDAx?=
 =?utf-8?B?KSg4NjM2MjAwMSkoNzY0ODIwMDEpKDU2Nzc2MDAxKSg3Nzk4MjAwMSkoNDc0?=
 =?utf-8?B?NDYwMDIpKDg4MTM2MDAyKSg1MTg1NjAwMSkoOTM1MTYwMDIpKDE5NTgwNDA1?=
 =?utf-8?B?MDAxKSg5NDk0NjAwMSkoMTk1ODAzOTUwMDMpO0RJUjpPVVQ7U0ZQOjExMDI7?=
 =?utf-8?B?U0NMOjE7U1JWUjpCTDJGRk8xMUhVQjAzMztIOlNKLUlURVhFREdFMDIuYWx0?=
 =?utf-8?B?ZXJhLnByaXYuYWx0ZXJhLmNvbTtGUFI6QUU0N0U2QjAuQjRENkRDMjkuMzRE?=
 =?utf-8?B?QUIzMC40NDg0MUU3MS4yMDI1MDtNTFY6c2Z2O1BUUjpJbmZvRG9tYWluTm9u?=
 =?utf-8?Q?existent;A:1;MX:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 01644DCF4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 16:48 -0500, Rob Herring wrote:
> On Fri, Mar 28, 2014 at 4:35 PM, Dinh Nguyen <dinguyen@altera.com> wrote:
> > On Fri, 2014-03-28 at 16:20 -0500, Rob Herring wrote:
> >> From: Rob Herring <robh@kernel.org>
> >>
> >> Add binding doc for Versatile platforms character LCD controller
> >> interface.
> >>
> >> Signed-off-by: Rob Herring <robh@kernel.org>
> >> Cc: Pawel Moll <pawel.moll@arm.com>
> >> Cc: Mark Rutland <mark.rutland@arm.com>
> >> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> >> Cc: Kumar Gala <galak@codeaurora.org>
> >> ---
> >>  Documentation/devicetree/bindings/misc/arm-charlcd.txt | 18 ++++++++++++++++++
> >>  1 file changed, 18 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/misc/arm-charlcd.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/misc/arm-charlcd.txt b/Documentation/devicetree/bindings/misc/arm-charlcd.txt
> >> new file mode 100644
> >> index 0000000..e28e2aa
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/misc/arm-charlcd.txt
> >> @@ -0,0 +1,18 @@
> >> +ARM Versatile Character LCD
> >> +-----------------------------------------------------
> >> +This binding defines the character LCD interface found on ARM Versatile AB
> >> +and PB reference platforms.
> >> +
> >> +Required properties:
> >> +- compatible : "arm,versatile-clcd"
> >
> > Should this be "arm,versatile-lcd"?
> 
> Make up your mind. ;) -lcd is what is already used in the dts, but
> since there was no driver support it should be okay to change the dts.
> If we're changing, I think I'll change it to "arm,versatile-char-lcd".
> 'c' alone could just mean color.

Sorry...what I meant was that in your patch, the examples was using
"lcd", and here's its "clcd". Then your 2/2 patch is using "lcd".

Dinh
> 
> Rob


