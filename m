Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3JaP5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:57:39 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:49340 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306Ab3JaP5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:57:39 -0400
Message-ID: <52727BCB.4010906@st.com>
Date: Thu, 31 Oct 2013 15:48:27 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RFC 2/2] regmap: move to using BITS_MASK macro
References: <1383220389-18420-1-git-send-email-srinivas.kandagatla@st.com> <1383220441-18519-1-git-send-email-srinivas.kandagatla@st.com> <20131031153833.GE2493@sirena.org.uk>
In-Reply-To: <20131031153833.GE2493@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/13 15:38, Mark Brown wrote:
> On Thu, Oct 31, 2013 at 11:54:01AM +0000, srinivas.kandagatla@st.com wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> This patch uses the new BITS_MASK macro for generating mask for multiple
>> bits.
> 
> Acked-by: Mark Brown <broonie@linaro.org>
Thanks Mark,
> 
> Or I can apply both.  There's plenty of other places this could be used.
> 
It makes sense to take it via regmap tree as there is dependency on the
first patch.

Thanks,
srini
