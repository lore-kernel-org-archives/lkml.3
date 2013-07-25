Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3GYIlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:41:06 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:54045 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754948Ab3GYIk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:40:57 -0400
Message-ID: <51F0E1E6.4010601@st.com>
Date: Thu, 25 Jul 2013 09:29:26 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-serial@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6] serial:st-asc: Add ST ASC driver.
References: <1373888363-10169-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1373888363-10169-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
Am not sure if you missed this patch.
Can you please consider this for 3.12.

Thanks,
srini

On 15/07/13 12:39, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch adds support to ASC (asynchronous serial controller)
> driver, which is basically a standard serial driver. This IP is common
> across all the ST parts for settop box platforms.
> 
> ASC is embedded in ST COMMS IP block. It supports Rx & Tx functionality.
> It support all industry standard baud rates.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> CC: Stephen Gallimore <stephen.gallimore@st.com>
> CC: Stuart Menefy <stuart.menefy@st.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Hi Greg,
> 
> This patch is the part of the driver support for Sti ARM SOCs.
> This patch undergone 3-4 cycles of review in arm-kernel mailing list.
> All the patches in that series went into 3.11.
> This patch is based on 3.11-rc1.
> 
> Am resending this patch, as it missed 3.11 window.
> Can you please consider this patch for 3.12.
> 
> Thanks,
> srini

