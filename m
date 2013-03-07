Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3CGLlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:41:03 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:56611 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932292Ab3CGLlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:41:01 -0500
Message-ID: <1362656455.5994.13.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: EXYNOS: change HAVE_SAMSUNG_KEYPAD to
 KEYBOARD_SAMSUNG
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 12:40:55 +0100
In-Reply-To: <014b01ce1acf$63ada580$2b08f080$%kim@samsung.com>
References: <1362566365.16460.173.camel@x61.thuisdomein>
	 <014b01ce1acf$63ada580$2b08f080$%kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2013 11:40:55.0842 (UTC) FILETIME=[A141F820:01CE1B28]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 10:02 +0900, Kukjin Kim wrote:
> BTW, just to use only 8~12 digits of commit ID, "Commit 6b5ab4f4" is
> enough instead of full commit ID.

I used to do that but now I actually prefer to use 40 hex character
strings.

Sure, they're ugly, but so are strings of 10, or 12 hex characters. But
they're easier to use (I can just copy/paste them from the output of,
say, "git log"), I do not have to worry about uniqueness, ever (some
commits now already need at least 8 characters), and some git web
interfaces automagically linkify 40 character hex strings in commit
explanations (which is quite nice).


Paul Bolle

