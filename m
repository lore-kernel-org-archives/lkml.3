Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422770AbaJaCrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:47:33 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:57866 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422689AbaJaCrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:47:32 -0400
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <12a11952cf1f7ee1c629af9da851bcba>
X-DNS-TYPE: 1
Message-ID: <5452F834.90303@rock-chips.com>
Date: Fri, 31 Oct 2014 10:47:16 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: dinguyen@opensource.altera.com, paulz@synopsys.com, balbi@ti.com
CC: dinh.linux@gmail.com, swarren@wwwdotorg.org, b.zolnierkie@samsung.com,
        matthijs@stdin.nl, r.baldyga@samsung.com, jg1.han@samsung.com,
        sachin.kamat@linaro.org, ben-linux@fluff.org, dianders@chromium.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 1/8] usb: dwc2: Update the gadget driver to use common
 dwc2_hsotg structure
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com> <1414538749-14735-2-git-send-email-dinguyen@opensource.altera.com>
In-Reply-To: <1414538749-14735-2-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh
On 10/29/2014 07:25 AM, dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>
> Adds the gadget data structure and appropriate data structure pointers
> to the common dwc2_hsotg data structure. To keep the driver data
> dereference code looking clean, the gadget variable declares are only available
> for peripheral and dual-role mode. This is needed so that the dwc2_hsotg data
> structure can be used by the hcd and gadget drivers.
>
> Updates gadget.c to use the dwc2_hsotg data structure and gadget pointers
> that have been moved into the common dwc2_hsotg structure.
Are we still need so much s3c prefix? Can we replace all the s3c into dwc2?

- Kever
