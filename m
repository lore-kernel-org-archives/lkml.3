Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaDHJgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:36:12 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:62024 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756131AbaDHJgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:36:10 -0400
Message-ID: <1396949767.26620.8.camel@x220>
Subject: Re: [PATCH] ARC: Remove ISS_SMP_EXTN entirely
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 08 Apr 2014 11:36:07 +0200
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751AC602@IN01WEMBXA.internal.synopsys.com>
References: <1396947368.26620.2.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230751AC602@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2014 09:36:07.0823 (UTC) FILETIME=[F80BB1F0:01CF530D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet,

On Tue, 2014-04-08 at 09:18 +0000, Vineet Gupta wrote:
> There's obvious bitrot here - however this code is not dead yet !
> I have a unpushed fix which uses this Kconfig item.

I see. Would it bother you if I send you a reminder if that fix (or
something equivalent) hasn't been added in some future release?

Thanks,


Paul Bolle

