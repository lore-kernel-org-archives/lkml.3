Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaGYL0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:26:34 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:47653 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914AbaGYL0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:26:32 -0400
Message-ID: <53D23ED6.9010502@synopsys.com>
Date: Fri, 25 Jul 2014 16:56:14 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.next,gmane.linux.kernel,gmane.linux.serial,gmane.linux.drivers.devicetree
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-next <linux-next@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        lkml <linux-kernel@vger.kernel.org>,
        greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: ARC fails to boot on linux-next of 20140711
References: <C2D7FE5348E1B147BCA15975FBA230753C4B67CF@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230753C4B67CF@IN01WEMBXA.internal.synopsys.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 July 2014 04:32 PM, Vineet Gupta wrote:
> 2014-03-27 a9296cf2d0b6 of: Create of_console_check() for selecting a console
> specified in /chosen 
> 2014-03-27 cfa9cacc5dd3 of: Enable console on serial ports specified by
> /chosen/stdout-path 
> 
> Is there a specific reason for dropping these patches (or perhaps a merge to be
> merged). I cherry-picked both but still doesn't work.

Correction - with these two, ARC boots again.

Thx,
-Vineet
