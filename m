Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3IRLw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:52:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36757 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751556Ab3IRLw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:52:28 -0400
Message-ID: <523993F9.6000705@free-electrons.com>
Date: Wed, 18 Sep 2013 13:52:25 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: srinivas.kandagatla@st.com
CC: stuart.menefy@st.com, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: STi: remove unused Kconfig parameters
References: <1379474622-4715-1-git-send-email-michael.opdenacker@free-electrons.com> <523949A1.7080600@st.com>
In-Reply-To: <523949A1.7080600@st.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srini

On 09/18/2013 08:35 AM, Srinivas KANDAGATLA wrote:
> Hi Michael.
> On 18/09/13 04:23, Michael Opdenacker wrote:
>> This patch proposes to remove the 'SOC_STIH415' and 'SOC_STIH416'
>> parameters, which are used nowhere else in the source code
>> and Makefiles.
>>
>> Will they be needed in code that hasn't been submitted yet?
> Yes, we will be using it in future patches, for something like reset
> controller.
> Also I am planning to use in dts/Makefiles so that we can build dtbs for
> only selected SOC.
>
> Thanks,
> srini
Thanks for your reply. That's fine for me if you have plans to use these
parameters.

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

