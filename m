Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaB0T6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:58:01 -0500
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:48115 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753651AbaB0T5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:57:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140227190102.GB4862@saruman.home>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
	<1393524848-8207-2-git-send-email-lho@apm.com>
	<20140227190102.GB4862@saruman.home>
Date: Thu, 27 Feb 2014 11:57:44 -0800
Message-ID: <CAPw-ZT=F07=T0=z=iT=hxJ0+609RBDYRL=MXF5dQoEowLjsRjQ@mail.gmail.com>
Subject: Re: [PATCH v12 1/4] PHY: Add function set_speed to generic PHY framework
From: Loc Ho <lho@apm.com>
To: balbi@ti.com
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Tejun Heo <tj@kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>,
        "patches@apm.com" <patches@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbi,

> On Thu, Feb 27, 2014 at 11:14:05AM -0700, Loc Ho wrote:
>> This patch adds function set_speed to the generic PHY framework operation
>> structure. This function can be called to instruct the PHY underlying layer
>> at specified lane to configure for specified speed in hertz.
>
> why ? looks like clk_set_rate() is your friend here. Can you be more
> descriptive of the use case ? When will this be used ?
>

The phy_set_speed is used to configure the operation speed of the PHY
at run-time. The clock interface in general is used to configure the
clock input to the IP. I don't believe they are the same thing. Maybe
it will be clear in my response to your second email

-Loc
