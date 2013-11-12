Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3KLOKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:10:38 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:36846 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482Ab3KLOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:10:35 -0500
Message-ID: <5282367D.1090705@st.com>
Date: Tue, 12 Nov 2013 14:09:01 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, <stephen.gallimore@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@stlinux.com>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH RFC 07/10] PM / wakeup : Introduce device_child_may_wakeup
References: <1384264311-7308-1-git-send-email-srinivas.kandagatla@st.com> <1384264377-7609-1-git-send-email-srinivas.kandagatla@st.com> <4093206.klj58BXQv3@vostro.rjw.lan>
In-Reply-To: <4093206.klj58BXQv3@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 14:20, Rafael J. Wysocki wrote:
>>  
>> > +/* callback for device_child_may_wakeup */
>> > +static int __device_child_may_wakeup(struct device *dev, void *c)
>> > +{
>> > +	return device_may_wakeup(dev);
>> > +}
> This doesn't have anything to do with children in principle, so please call
> it differently.  Something like device_may_wakeup_cb() would work for me (and
> then you may not need the comment even).

Thanks Rafael, I will fix this in next version.
> 
> Thanks!
> 
>> > +
>> > +/**

