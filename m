Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3KUWga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:36:30 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:63455 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3KUWg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:36:27 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Julien DELACOU <julien.delacou@st.com>,
        Matthijs Kooijman <matthijs@stdin.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Grant Likely" <grant.likely@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: RE: [PATCH] staging: dwc2: add check on dwc2_core_reset return
Thread-Topic: [PATCH] staging: dwc2: add check on dwc2_core_reset return
Thread-Index: AQHO5g3gtNblcQfpR02PEFil3RI5PZowR79A
Date: Thu, 21 Nov 2013 22:36:21 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458E293B5@US01WEMBX2.internal.synopsys.com>
References: <1384964989-28760-1-git-send-email-julien.delacou@st.com>
In-Reply-To: <1384964989-28760-1-git-send-email-julien.delacou@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Julien DELACOU [mailto:julien.delacou@st.com]
> Sent: Wednesday, November 20, 2013 8:30 AM
> 
> If the GRSTCTL_CSFTRST self-clearing bit never comes
> back to 0 for any reason, the controller is under reset
> state and cannot be used. It's preferable to abort
> initialization in such case.
> 
> Signed-off-by: Julien Delacou <julien.delacou@st.com>
> ---
>  drivers/staging/dwc2/core.c |   58 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 45 insertions(+), 13 deletions(-)

Acked-by: Paul Zimmerman <paulz@synopsys.com>

