Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab3EHSXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:23:31 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:58666 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757747Ab3EHSX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:23:29 -0400
Message-ID: <518A96DA.5060809@st.com>
Date: Wed, 08 May 2013 19:18:02 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, jslaby@suse.cz,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        linux-serial@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022248-2153-1-git-send-email-srinivas.kandagatla@st.com> <201305081634.43498.arnd@arndb.de> <20130508143908.GJ24282@game.jcrosoft.org>
In-Reply-To: <20130508143908.GJ24282@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 15:39, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>> +
>> > 
>> > Please remove all forward declarations, by reordering the functions in
>> > the way they are called.
>> > 
> and drop the dummy functions
We can not remove the dummy functions, as the serial-core does not check
it before using them.
>> > 
>>> > > diff --git a/drivers/tty/serial/st-asc.h b/drivers/tty/serial/st-asc.h
>>> > > new file mode 100644
>>> > > index 0000000..e59f818
>>> > > --- /dev/null
>>> > > +++ b/drivers/tty/serial/st-asc.h

