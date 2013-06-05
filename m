Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3FEOm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:42:29 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:53769 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007Ab3FEOm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:42:27 -0400
Message-ID: <51AF4E19.8050509@st.com>
Date: Wed, 05 Jun 2013 15:41:29 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] regmap: Add regmap_field APIs
References: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com> <20130604210137.GV31367@sirena.org.uk> <51AF0313.6000205@st.com> <20130605114140.GW31367@sirena.org.uk>
In-Reply-To: <20130605114140.GW31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou for reviewing the patch.
On 05/06/13 12:41, Mark Brown wrote:
> On Wed, Jun 05, 2013 at 10:21:23AM +0100, Srinivas KANDAGATLA wrote:
> I think I'd prefer to see a struct passed in here for the field
> definition - this would make it easier to initialise from static data,
> otherwise people will end up writing a loop that reads from a locally
> defined struct once they get more than a couple of fields.
> 
I will modify the APIs to take reg_field structure instead of reg, lsb,
and msb arguments.

Is it Ok If I send this patch with my "STiH41x SOC support series", as
we can see the actual usage of this new apis in the follow on patches?

Thanks,
srini
> Otherwise this makes sense.
> 

