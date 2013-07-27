Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3G0PNh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 11:13:37 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43797 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3G0PNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 11:13:34 -0400
Message-ID: <51F3E39A.2060203@cogentembedded.com>
Date: Sat, 27 Jul 2013 19:13:30 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Prashant Shah <pshah.mumbai@gmail.com>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Andy Shevchenko <andy.shevchenko@gmail.com>, whiteheadm@acm.org,
        Ryan Mallon <rmallon@gmail.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com, kernel-mentors@selenic.com
Subject: Re: [PATCH] Change request_irq() to use struct net_device *dev->name
References: <1374646199-9398-1-git-send-email-pshah.mumbai@gmail.com> <51F07489.7010404@gmail.com> <CAD6i1fJO3geZ0vkHLsJEd+KedHkpC1OZVTJJskU2RAAKYBhhJQ@mail.gmail.com> <CAD6i1f+NYu7rcQwF-TXk4+OdjPNZwMKxxjJ9YA_+v9B6uPYq+g@mail.gmail.com> <CAHp75VdouA2w5WjBPJ2cX8AKvTeCNrj6pM+3SS5DzU+ARM5M3Q@mail.gmail.com> <CAP8WD_aKqqB4Fb4Vadj_AJ4ET5gxd+EkaCMMVvBxxqNwDjpBGg@mail.gmail.com> <CAHp75VeqgqVdn+zRjW+McwFQfD73NhYz4X3M4ndeDZnkFmqyEg@mail.gmail.com> <51F16F74.3070503@cogentembedded.com> <20130725183824.GA32658@blackmetal.musicnaut.iki.fi> <CAD6i1fKra9Z8C=jm-KYuWPwxd=u-8HMo8b=XJJOo8aS+4SdmWg@mail.gmail.com>
In-Reply-To: <CAD6i1fKra9Z8C=jm-KYuWPwxd=u-8HMo8b=XJJOo8aS+4SdmWg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27-07-2013 12:58, Prashant Shah wrote:

>>>     It's also called managed device API. In fact, I've never heard it
>>> named devres API.

> If I understood it correctly it has to just calls
> devm_request_region() with the struct device pointer and there are no
> deallocation functions to call ? It manages deallocation on it own.

    Yes.

> Regards.

WBR, Sergei

