Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab3GOWik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:38:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46173 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab3GOWij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:38:39 -0400
Message-ID: <51E479D0.4040304@zytor.com>
Date: Mon, 15 Jul 2013 15:38:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: David Woodhouse <dwmw2@infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
References: <1373916476.2748.69.camel@dabdike> <20130715201943.GA22131@roeck-us.net> <1373925868.24167.35.camel@shinybook.infradead.org> <20130715220730.GA23916@roeck-us.net>
In-Reply-To: <20130715220730.GA23916@roeck-us.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 03:07 PM, Guenter Roeck wrote:
> On Mon, Jul 15, 2013 at 11:04:28PM +0100, David Woodhouse wrote:
>> On Mon, 2013-07-15 at 13:19 -0700, Guenter Roeck wrote:
>>> That seems to be a bit drastic. It is quite useful to have the tag,
>>> but maybe it should only be added by the maintainer and not in the initial
>>> patch submission. This would ensure that the maintainer(s) made the decision.
>>> If the original patch submitter thinks that the patch is stable material,
>>> that information could be added in the comments section.
>>
>> In the case where a maintainer applies a patch with 'git am', surely
>> they can *see* that it's cc:stable?
>>
> If that maintainer is careful, yes. But that isn't the point or idea. The
> difference is that the maintainer would have to make an active decision
> to add the cc:stable tag vs. just going along with it.
> 

WTF?  If a maintainer applies a patch and misses that the thing had a
Cc: <stable> tag, that maintainer should never have applied the patch in
the first place.

It gets stickier in the case of submaintainers where there are git pulls
involved.

	-hpa


