Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaHURUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:20:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39806 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaHURUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:20:07 -0400
Message-ID: <53F62A2B.6010208@ti.com>
Date: Thu, 21 Aug 2014 12:19:39 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Murphy, Dan" <dmurphy@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 2/2] Input: misc: introduce palmas-pwrbutton
References: <1408392810-16011-1-git-send-email-nm@ti.com> <1408636935-29515-1-git-send-email-nm@ti.com> <1408636935-29515-3-git-send-email-nm@ti.com> <00FC9A978A94B7418C33AFAE8A35ED49DF0662@DFLE09.ent.ti.com>
In-Reply-To: <00FC9A978A94B7418C33AFAE8A35ED49DF0662@DFLE09.ent.ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 11:59 AM, Murphy, Dan wrote:
[...]
Ooops.. missed answering one addition statement:

>> +	of_property_read_u32(np, "ti,palmas-long-press-seconds", &val);
> 
> Probably should check the return to make sure the value exists and that is is
> within an expected range.
It is an optional parameter and may not exist in dt. when it does
exist, the logic tries to do a best match (this is the for loop in the
logic just below).

-- 
Regards,
Nishanth Menon
